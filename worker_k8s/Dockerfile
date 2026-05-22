# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS builder
WORKDIR /src

COPY ["Worker.csproj", "."]
RUN dotnet restore "Worker.csproj"

COPY . .
RUN dotnet publish "Worker.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore

# Stage 2: Final Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app

# -S: System user, -G: Group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder --chown=appuser:appgroup /app/publish .

USER appuser

ENTRYPOINT ["dotnet", "Worker.dll"]
