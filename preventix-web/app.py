from flask import Flask, request, jsonify, render_template_string
import torch
import torch.nn as nn
import numpy as np

app = Flask(__name__)

# ---------------- Model Class (same as before) ---------------- #
class SepsisPredictor(nn.Module):
    def __init__(self, input_dim, hidden_dim=128):
        super(SepsisPredictor, self).__init__()
        self.lstm = nn.LSTM(input_dim, hidden_dim, batch_first=True, bidirectional=True)
        self.attn = nn.Linear(hidden_dim * 2, 1)
        self.norm = nn.LayerNorm(hidden_dim * 2)
        self.dropout = nn.Dropout(0.3)
        self.classifier = nn.Sequential(
            nn.Linear(hidden_dim * 2, 64),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(64, 2)
        )

    def forward(self, x, mask):
        lstm_out, _ = self.lstm(x)
        attn_weights = self.attn(lstm_out).squeeze(-1)
        attn_weights = attn_weights.masked_fill(mask == 0, -1e9)
        attn_scores = torch.softmax(attn_weights, dim=1).unsqueeze(-1)
        context = torch.sum(attn_scores * lstm_out, dim=1)
        context = self.norm(context)
        context = self.dropout(context)
        return self.classifier(context)

# ---------------- Load Model ---------------- #
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = SepsisPredictor(input_dim=14)
model.load_state_dict(torch.load("sepsis_model.pt", map_location=device))
model.to(device)
model.eval()

def preprocess_new_sequence(new_seq, input_dim=14, max_len=100):
    new_seq = torch.tensor(new_seq, dtype=torch.float)
    if new_seq.shape[1] != input_dim:
        raise ValueError(f"Expected {input_dim} features, got {new_seq.shape[1]}.")
    seq_len = new_seq.shape[0]
    padded = torch.zeros((max_len, input_dim))
    padded[:seq_len] = new_seq
    mask = torch.zeros(max_len, dtype=torch.long)
    mask[:seq_len] = 1
    return padded.unsqueeze(0), mask.unsqueeze(0)

def predict(new_seq):
    x, mask = preprocess_new_sequence(new_seq)
    x, mask = x.to(device), mask.to(device)
    with torch.no_grad():
        logits = model(x, mask)
        probs = torch.softmax(logits, dim=1)
        pred_class = torch.argmax(probs, dim=1).item()
    return pred_class, probs.cpu().numpy().tolist()

# ---------------- Frontend Route ---------------- #
@app.route("/")
def home():
        return render_template_string("""
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sepsis Prediction Interface</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f4f6f8;
      color: #333;
      padding: 30px;
      max-width: 900px;
      margin: auto;
    }

    h2 {
      color: #2c3e50;
    }

    textarea {
      width: 100%;
      height: 180px;
      font-size: 14px;
      padding: 12px;
      border: 1px solid #ccc;
      border-radius: 8px;
      box-sizing: border-box;
      background-color: #fff;
      resize: vertical;
    }

    button {
      background-color: #3498db;
      color: white;
      border: none;
      padding: 12px 24px;
      font-size: 16px;
      border-radius: 6px;
      cursor: pointer;
      margin-top: 10px;
    }

    button:hover {
      background-color: #2980b9;
    }

    #output {
      margin-top: 25px;
      padding: 15px;
      background-color: #fff;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 16px;
    }

    .info {
      font-size: 14px;
      margin-bottom: 12px;
      color: #555;
    }

    .note {
      background-color: #fef9e7;
      padding: 10px;
      border-left: 5px solid #f1c40f;
      margin-top: 20px;
      font-size: 14px;
      border-radius: 5px;
    }

    .success { color: green; }
    .danger { color: red; }

    .features-box {
      font-family: monospace;
      font-size: 13px;
      background-color: #eef3f7;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #cdd2d6;
      margin-bottom: 12px;
      white-space: pre-wrap;
    }
  </style>
</head>
<body>
  <h2>🧪 Sepsis Prediction Tool</h2>
  <div class="info">
    🔹 Enter a patient's <strong>normalized time-series input</strong> below.<br>
    🔹 Each line = one timestep (14 comma-separated values)<br>
    🔹 Min 1 line, max 100 lines.
  </div>

  <div class="features-box">
    🔍 Feature order (per line):<br>
    [0] HeartRate, [1] O2Sat, [2] Temp, [3] SBP, [4] MAP, [5] DBP, [6] Resp,<br>
    [7] BaseExcess, [8] HCO3, [9] FiO2, [10] CRP, [11] Lactate,<br>
    [12] Bilirubin, [13] BUN
  </div>

  <textarea id="inputData" placeholder="e.g. 0.1, 0.2, -0.3, ..., 0.05"></textarea>
  <br>
  <button onclick="makePrediction()">🧠 Predict</button>

  <div id="output"></div>

  <div class="note">
    ℹ️ <strong>Note:</strong> This model was trained on normalized inputs. Ensure your inputs are scaled properly before submitting.
  </div>

  <script>
    async function makePrediction() {
      const rawText = document.getElementById("inputData").value;
      const lines = rawText.trim().split("\\n");
      const sequence = lines.map(line => line.trim().split(",").map(Number));

      const response = await fetch("/predict", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sequence })
      });

      const result = await response.json();
      if (response.ok) {
        document.getElementById("output").innerHTML = `
          <div>Prediction: <span class="${result.prediction === 'Sepsis' ? 'danger' : 'success'}">
            ${result.prediction}
          </span></div>
          <div>Class Probabilities: <code>${JSON.stringify(result.probabilities)}</code></div>
        `;
      } else {
        document.getElementById("output").innerHTML = "<span class='danger'>Error: " + result.error + "</span>";
      }
    }
  </script>
</body>
</html>

""")


# ---------------- Predict API ---------------- #
@app.route("/predict", methods=["POST"])
def predict_route():
    data = request.json
    if "sequence" not in data:
        return jsonify({"error": "Missing 'sequence' in request"}), 400

    try:
        sequence = np.array(data["sequence"])
        pred_class, probs = predict(sequence)
        return jsonify({
            "prediction": "Sepsis" if pred_class == 1 else "No Sepsis",
            "probabilities": probs
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ---------------- Run Server ---------------- #
if __name__ == "__main__":
    app.run(debug=True)
