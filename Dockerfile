FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["devopswebapp.csproj", "./"]
RUN dotnet restore "devopswebapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "devopswebapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "devopswebapp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "devopswebapp.dll"]
