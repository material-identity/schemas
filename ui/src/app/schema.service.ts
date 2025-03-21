import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { first, firstValueFrom } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class SchemaService {
  private readonly http = inject(HttpClient);

  constructor() {}

  async render(
    certificate: Record<string, unknown>,
    attachJson: boolean = true
  ) {
    const url = `${this.getServerUrl()}/api/render`;

    try {
      const res = await firstValueFrom(
        this.http.post(url, certificate, {
          params: { attachJson: attachJson.toString() },
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

  getServerUrl() {
    try{
      const baseUrl = `${window.location.protocol}//${window.location.hostname}`;

      if(baseUrl.includes('localhost')) {
        return `${baseUrl}:${window.location.port}`;
      }
      else {
        return baseUrl;
      }
    }
    catch (e) {
      console.log("Error while creating serverUrl: ", e);
      return "https://schemas-service.development.s1seven.com";
    }
  }
}
