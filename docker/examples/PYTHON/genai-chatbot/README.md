# Video Analysis and Transcription ChatBot using Docker GenAI Stack

The application is a chatbot that can answer questions from a video. Additionally, it provides timestamps from the
video that can help you to find the sources used to answer your question.

## Getting Started


- Create an [OpenAI API Key](https://platform.openai.com/account/api-keys).
- Ensure that you have a [Pinecone API Key](https://app.pinecone.io/).
- Ensure that you have installed the [latest version of Docker Desktop](https://www.docker.com/products/docker-desktop/).

##  Clone the repository


```
git clone https://github.com/dockersamples/docker-genai.git
```

## Specify your API keys

In the /docker-genai directory, create a text file called .env and specify your API keys inside. The following is the contents of the .env.example file that you can refer to as an example.


```
#-------------------------------------------------------------
# OpenAI
#-------------------------------------------------------------
OPENAI_TOKEN=your-api-key # Replace your-api-key with your personal API key

#-------------------------------------------------------------
# Pinecone
#--------------------------------------------------------------
PINECONE_TOKEN=your-api-key # Replace your-api-key with your personal API key
```

## Build and Run the application

```
 docker compose up --build
```

Docker Compose builds and runs the application based on the services defined in the docker-compose.yaml file. When the application is running, you'll see the logs of 2 services in the terminal.
In the logs, you'll see the services are exposed on ports 8503 and 8504. The two services are complementary to each other.
The yt-whisper service is running on port 8503. This service feeds the Pinecone database with videos that you want to archive in your knowledge database. The following section explores this service.

Open a browser and access the yt-whisper service at  `http://localhost:8503` .
