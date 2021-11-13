import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

// Demo configuration service
type ConfigurationType = { jaeger_port: number; delay: string | boolean; port: string; jaeger_endpoint: string; name: string; jaeger_host: string }

let config: () => ConfigurationType;
config = () => {
  return {
    port: process.env.PORT,
    name: process.env.NAME,
    delay: process.env.DELAY || false,
    jaeger_port: Number.parseInt(process.env.JAEGER_PORT),
    jaeger_host: process.env.JAEGER_HOST,
    jaeger_endpoint: process.env.JAEGER_ENDPOINT,
  }
};

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // basic settings (demo)
  Logger.log(`Starting SRE Demo (NodeJs) service [${config().name.toUpperCase()}] in port ${config().port}`)
  Logger.log(`Jaeger host: ${config().jaeger_host}`)
  Logger.log(`Jaeger port: ${config().jaeger_port}`)
  Logger.log(`Jaeger endpoint: ${config().jaeger_endpoint}`)

  await app.listen(config().port);
}

bootstrap();
