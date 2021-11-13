import { JaegerExporter } from '@opentelemetry/exporter-jaeger';
import {ConfigurationType} from "./configurationManager";

class ExporterFactory{
    /**
     * Get Jaeger exporter configuration
     */
    public getExporter(config: ConfigurationType) {
        const options: { endpoint: string; maxPacketSize: number; tags: any[] } = {
            tags: [], // optional TODO: Add later this option
            endpoint: config.jaeger_endpoint,
            maxPacketSize: 65000 // optional, TODO : customise later
        };

        const exporter: JaegerExporter = new JaegerExporter(options);
        return exporter;
    }
}

export { ExporterFactory }
