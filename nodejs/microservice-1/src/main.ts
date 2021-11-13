import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import tracer from './lib/otel/tracer'
import { Logger } from '@nestjs/common';
import {ConfigurationManager, ConfigurationType} from "./lib/otel/configurationManager";

// OpenTelemetry configuration
const config: ConfigurationType = new ConfigurationManager().getConfiguration();
tracer(config)

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // basic settings (demo)
  Logger.log(`Starting SRE Demo (NodeJs) service [${config.name.toUpperCase()}] in port ${config.port}`)
  Logger.log(`Jaeger host: ${config.jaeger_host}`)
  Logger.log(`Jaeger port: ${config.jaeger_port}`)
  Logger.log(`Jaeger endpoint: ${config.jaeger_endpoint}`)

  await app.listen(config.port);
}

bootstrap();
