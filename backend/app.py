from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin
cred = credentials.Certificate('path_to_your_firestore_key.json')
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

app = Flask(__name__)

@app.route('/')
def index():
    return "Genesis Backend is up and running!"

@app.route('/interactions', methods=['GET'])
def get_interactions():
    """Endpoint to fetch all interactions"""
    interactions_ref = db.collection('interactions')
    interactions = interactions_ref.stream()

    interactions_list = []
    for interaction in interactions:
        interactions_list.append(interaction.to_dict())

    return jsonify(interactions_list)

@app.route('/interaction', methods=['POST'])
def log_interaction():
    """Endpoint to log a new interaction"""
    data = request.json
    question = data.get('question')
    answer = data.get('answer')

    interactions_ref = db.collection('interactions')
    interactions_ref.add({
        'question': question,
        'answer': answer
    })

    return jsonify({"message": "Interaction logged successfully!"}), 201

@app.route('/interactions/count', methods=['GET'])
def get_interaction_count():
    """Endpoint to get the total count of interactions"""
    interactions_ref = db.collection('interactions')
    interactions_count = len(list(interactions_ref.stream()))

    return jsonify({"count": interactions_count})

if __name__ == '__main__':
    app.run(debug=True)
