import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { first, firstValueFrom } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class SchemaService {
  private readonly http = inject(HttpClient);

  constructor() {}

  async render(
    certificate: Record<string, unknown>,
    schemaType = 'CoA',
    schemaVersion = 'v1.1.0',
    languages = 'CN, EN'
  ) {
    // Retrieve port from environment variables with a default value
    const port = '8081';
    const url = `http://localhost:${port}/api/render`;

    try {
      const res = await firstValueFrom(
        this.http.post(url, certificate, {
          params: {
            schemaType,
            schemaVersion,
            languages,
          },
          responseType: 'blob',
        })
      );
      console.log({ res });
      const blob = new Blob([res], { type: 'application/pdf' });
      const blobUrl = window.URL.createObjectURL(blob);
      window.open(blobUrl);
    } catch (error) {
      console.error('Error rendering PDF:', error);
    }
  }
}
