# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gke_quickstarts_languages_dotnet_dockerfile]
# Use Microsoft's official lightweight .NET images.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Install production dependencies.
# Copy csproj and restore as distinct layers.
COPY *.csproj ./
RUN dotnet restore

# Copy local code to the container image.
COPY . ./

# Build a release artifact.
RUN dotnet publish -c Release -o out

# Run the web service on container startup in a lean production image.
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .

# Start the .dll (will have the same name as your .csproj file)
ENTRYPOINT ["dotnet", "helloworld-gke.dll"]
# [END gke_quickstarts_languages_dotnet_dockerfile]
