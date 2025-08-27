# model_utils.py
import torch
import torch.nn as nn
import numpy as np

# Define model class
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

# Load model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = SepsisPredictor(input_dim=14).to(device)
model.load_state_dict(torch.load("sepsis_model.pt", map_location=device))
model.eval()

def preprocess_input(seq, max_len=100):
    seq = torch.tensor(seq, dtype=torch.float32)
    padded = torch.zeros((max_len, seq.shape[1]))
    mask = torch.zeros(max_len, dtype=torch.long)
    seq_len = seq.shape[0]
    padded[:seq_len] = seq
    mask[:seq_len] = 1
    return padded.unsqueeze(0), mask.unsqueeze(0)

def predict_sequence(input_sequence):
    x, mask = preprocess_input(np.array(input_sequence))
    x, mask = x.to(device), mask.to(device)
    with torch.no_grad():
        logits = model(x, mask)
        probs = torch.softmax(logits, dim=1).cpu().numpy()
        prediction = int(np.argmax(probs, axis=1)[0])
    return prediction, probs.tolist()[0]
