import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset

# Example dummy neural network
class SimpleModel(nn.Module):
    def __init__(self):
        super(SimpleModel, self).__init__()
        self.fc = nn.Linear(10, 1)
    
    def forward(self, x):
        return self.fc(x)

# Check if GPUs are available
if torch.cuda.is_available():
    # Get the number of available GPUs
    num_gpus = torch.cuda.device_count()
    print(f"Using {num_gpus} GPUs.")

    # Use DataParallel to spread the model across all available GPUs
    model = SimpleModel()
    model = nn.DataParallel(model)  # This distributes the model across all available GPUs
    model = model.cuda()  # Move the model to GPU
else:
    print("No GPU available, using CPU.")
    model = SimpleModel()

# Create some dummy data for training
x_train = torch.randn(1000, 10)  # 1000 samples, 10 features each
y_train = torch.randn(1000, 1)   # 1000 target values

# Prepare the dataset and dataloader
dataset = TensorDataset(x_train, y_train)
dataloader = DataLoader(dataset, batch_size=32, shuffle=True)

# Define a simple optimizer and loss function
optimizer = optim.SGD(model.parameters(), lr=0.01)
criterion = nn.MSELoss()

# Training loop
model.train()
for epoch in range(5):  # Train for 5 epochs
    for batch_idx, (data, target) in enumerate(dataloader):
        # Move data to GPU if available
        if torch.cuda.is_available():
            data, target = data.cuda(), target.cuda()

        # Forward pass
        output = model(data)
        loss = criterion(output, target)

        # Backward pass and optimization
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch_idx % 10 == 0:
            print(f"Epoch [{epoch+1}/5], Batch [{batch_idx}], Loss: {loss.item():.4f}")

print("Training completed.")

