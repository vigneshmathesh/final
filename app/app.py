from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 Flask App Deployed with Terraform and GitHub Actions!"

# ✅ This part is critical
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
