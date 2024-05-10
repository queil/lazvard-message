FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /build

COPY src/Lazvard.Message.Cli/Lazvard.Message.Cli.csproj src/Lazvard.Message.Cli/
COPY src/Lazvard.Message.Amqp.Server/Lazvard.Message.Amqp.Server.csproj src/Lazvard.Message.Amqp.Server/

RUN dotnet restore ./src/Lazvard.Message.Cli/  -r linux-x64

COPY . .

RUN dotnet publish ./src/Lazvard.Message.Cli/ --no-restore -c Release -r linux-x64 -o ./pub/cli

FROM mcr.microsoft.com/dotnet/runtime:8.0

WORKDIR /app

COPY --from=0 /build/pub/ ./

WORKDIR /app/cli

ENTRYPOINT ["/app/cli/Lazvard.Message.Cli"]
