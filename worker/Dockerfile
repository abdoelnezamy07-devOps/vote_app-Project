# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS builder
WORKDIR /src
COPY ["Worker.csproj", "./"]
RUN dotnet restore "Worker.csproj"
COPY . .
RUN dotnet publish "Worker.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore
# Stage 2: Final Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
USER app
COPY --from=builder --chown=app:app /app/publish .
ENTRYPOINT ["dotnet", "Worker.dll"]


# # Stage 1: Build
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
# WORKDIR /src
# COPY ["worker.csproj", "./"]
# RUN dotnet restore
# COPY . .
# RUN dotnet publish "worker.csproj" -c Release -o /app/publish /p:UseAppHost=false

# # Stage 2: Final Runtime
# FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
# WORKDIR /app
# USER app
# COPY --from=builder --chown=app:app /app/publish .
# # ENV ASPNETCORE_URLS=http://+:8080
# # EXPOSE 8080
# ENTRYPOINT ["dotnet", "worker.dll"]
