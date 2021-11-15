import {DotenvConfigOutput, DotenvParseOutput} from "dotenv";

type ConfigurationType = { jaeger_port: number; jaeger_exporter_http: string | undefined; delay: string | boolean; port: number; jaeger_endpoint: string | undefined; name: string; jaeger_host: string }
import { Logger } from '@nestjs/common';
import * as dotenv from "dotenv";


class ConfigurationManager{

    /**
     * Get the Jaeger HTTP endpoint configuration
     * @param host
     * @param port
     */
    getJaegerExporterHTTPEndpoint(
        host: string | undefined,
        port: number | undefined): string {
        const jaeger_port: number = port ?? 16686;
        const jaeger_host: string = host ?? 'http://localhost';
        const endpoint: string = `${jaeger_host}:${jaeger_port.toString()}/api/traces`

        Logger.log(`To send metrics to jaeger exporter endpoint => ${endpoint}`)

        return endpoint;
    }

    /***
     * Get local environment configuration
     */
    getLocalEnvConfig(): DotenvParseOutput {
        const localConfig: DotenvConfigOutput = dotenv.config({ path: `${__dirname}/.env` });
        return localConfig.parsed;
    }

    /**
     * Get Jaeger exporter configuration
     */
    public getConfiguration(): ConfigurationType {

        const isLocal: boolean = !(process.env.IS_LOCAL === null || process.env.IS_LOCAL === 'false')

        if (isLocal) {
            const localConfig = this.getLocalEnvConfig()
            console.log(localConfig)
        }

        const jaeger_port: number = Number.parseInt(process.env.PORT);
        const jaeger_host: string = process.env.JAEGER_HOST;
        const jaeger_endpoint: string = this.getJaegerExporterHTTPEndpoint(jaeger_host, jaeger_port);

        const config: ConfigurationType = {
            jaeger_exporter_http: undefined,
            port: Number.parseInt(process.env.PORT),
            name: process.env.NAME,
            delay: process.env.DELAY || false,
            jaeger_port,
            jaeger_host,
            jaeger_endpoint
        }

        Logger.log(`Configuration built => ${JSON.stringify(config)}`)

        return config
    }
}

export { ConfigurationManager, ConfigurationType }
