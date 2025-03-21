import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { first, firstValueFrom } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class SchemaService {
  private readonly http = inject(HttpClient);
  private readonly thrustedServerUrls = [
    "http://localhost:8081",
    "https://schemas-service.development.s1seven.com",
    "https://schemas-service.staging.s1seven.com",
    "https://schemas-service.s1seven.com"
  ];

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
      const devUrl = "https://schemas-service.development.s1seven.com";
      let url = devUrl;

      if(baseUrl.includes('localhost')) {
        url = `${baseUrl}:${window.location.port}`;
      }
      else {
        url = baseUrl;
      }

      if (thrustedServerUrls.includes(url)) {
        return url;
      }
    }
    catch (e) {
      console.log("Error while creating serverUrl: ", e);
      return devUrl;
    }
  }
}
