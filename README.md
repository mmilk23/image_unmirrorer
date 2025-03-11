# Image Unmirrorer

[![Build Status](https://github.com/mmilk23/image_unmirrorer/actions/workflows/elixir.yml/badge.svg)](https://github.com/mmilk23/image_unmirrorer/actions)
[![codecov](https://codecov.io/gh/mmilk23/image_unmirrorer/branch/main/graph/badge.svg)](https://codecov.io/gh/mmilk23/image_unmirrorer)
[![Coverage Status](https://coveralls.io/repos/github/mmilk23/image_unmirrorer/badge.svg)](https://coveralls.io/github/mmilk23/image_unmirrorer)
![Dependabot](https://img.shields.io/badge/Dependabot-enabled-brightgreen)
[![Last Updated](https://img.shields.io/github/last-commit/mmilk23/image_unmirrorer.svg)](https://github.com/mmilk23/image_unmirrorer/commits/main)


The **Image Unmirrorer** 

This project provides a set of APIs for image manipulation and processing, currently under active development. The /mirror endpoint allows users to upload an image and receive a horizontally mirrored version, while the /grayscale endpoint returns a grayscale version of the uploaded image.

Developed in Elixir and containerized with Docker, the project is easy to set up and deploy. It serves as an excellent example application for newcomers to Elixir programming, demonstrating fundamental concepts in API design and image processing.

## Features
- Mirrors/grayscale uploaded images (supports JPEG and PNG formats).
- Easy integration via RESTful API.

## Live Demo 🌟

Explore the features of the application through the link below:

🔗 [Try the Live Demo](https://image-unmirrorer.gigalixirapp.com/testmirror.html) (https://image-unmirrorer.gigalixirapp.com/testgrayscale.html)

### OpenAPI Specification
To access the API specification (OpenAPI), click the link below:

📜 [View OpenAPI Spec](https://image-unmirrorer.gigalixirapp.com/openapi.json)


## How to Run the Project

### Requirements
- Docker
- Elixir (if you wish to run it locally without Docker)

### Running with Docker
1. Clone the repository:
   ```sh
   git clone https://github.com/mmilk23/image_unmirrorer.git
   cd image_unmirrorer
   ```

2. Build and run the container:
   ```sh
   docker build -t image_unmirrorer .
   docker run -p 4000:4000 image_unmirrorer
   ```

3. Access the application in your browser:
   ```
   http://localhost:4000
   ```

### Running Locally (Without Docker)
1. Clone the repository:
   ```sh
   git clone https://github.com/mmilk23/image_unmirrorer.git
   cd image_unmirrorer
   ```

2. Install dependencies:
   ```sh
   mix deps.get
   ```

3. Compile the project:
   ```sh
   mix clean
   mix compile
   ```

4. Run the application:
   ```sh
   mix run --no-halt
   ```

5. Access the application in your browser:
   ```
   http://localhost:4000
   ```

## API Endpoints
- **POST /mirror**: Receives an image and returns its horizontally mirrored version.
- **POST /grayscale**: Receives an image and returns a grayscale version of the image.
- **GET /openapi.json**: Provides the OpenAPI specification for the API.


### Example Request
```sh
curl -X POST http://localhost:4000/mirror -H "Content-Type: image/jpeg" --data-binary @your_image.jpg -o image-mirror.jpg
```

## Testing
You can test the application by accessing the `testmirror.html` file in your browser:
```
http://localhost:4000/testmirror.html
http://localhost:4000/testgrayscale.html
```

Alternatively, you can use a CURL command:
```sh
curl -X POST -H "Content-Type: image/jpeg" --data-binary @your_image.jpg http://localhost:4000/mirror --output image-mirror.jpg
```

To run coverage tests:
```sh
mix test --cover
```

## Technologies Used
- Elixir
- Docker

## Contributing
Contributions are more than welcome! 
Feel free to submit a pull request or open an issue to discuss improvements or report bugs.

## License
This project is licensed under the MIT License.

## Disclaimer
This project was developed as part of a system architecture playground and is not recommended for production environments without an in-depth review.

If you found this project helpful, please consider giving it a star ⭐️.

## Contact
For more information, visit the [GitHub repository](https://github.com/mmilk23/image_unmirrorer).