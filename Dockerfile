#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#Testing

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80


FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["dockerexample.csproj", "."]
RUN dotnet restore "./dockerexample.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerexample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerexample.csproj" -c Release -o /app/publish 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerexample.dll"]