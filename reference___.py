import tensorflow as tf
import numpy as np
from PIL import Image

def load_model(model_path):
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

def preprocess_image(image_path, input_shape):
    image = Image.open(image_path).convert('RGB')
    image = image.resize((input_shape[1], input_shape[2]))
    image_array = np.array(image, dtype=np.float32)
    image_array = np.expand_dims(image_array, axis=0)  # Add batch dimension
    image_array = image_array / 255.0  # Normalize to [0, 1]
    return image_array

def classify_image(interpreter, image_array):
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    # Set the input tensor
    interpreter.set_tensor(input_details[0]['index'], image_array)

    # Run inference
    interpreter.invoke()

    # Get the output tensor
    output_data = interpreter.get_tensor(output_details[0]['index'])
    return output_data

# Map predictions to labels
def get_label(predictions, labels):
    predicted_index = np.argmax(predictions)
    return labels[predicted_index]

if __name__ == "__main__":
    model_path = "model/tooth_classification_model.tflite"

    image_path = "image3.png"

    labels = ["No Caries", "Intermediate Caries", "Advanced Caries"]

    # Load the model
    interpreter = load_model(model_path)

    # Get input shape
    input_details = interpreter.get_input_details()
    input_shape = input_details[0]['shape']

    image_array = preprocess_image(image_path, input_shape)

    predictions = classify_image(interpreter, image_array)

    print(predictions)

    predicted_label = get_label(predictions, labels)

    print(f"Predicted Caries Type: {predicted_label}")
    print("Confidence levels:")
    for label, confidence in zip(labels, predictions[0]):
        print(f"{label}: {confidence * 100:.2f}%")