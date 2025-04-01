import { HttpClient } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { first, firstValueFrom } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class SchemaService {
  private readonly http = inject(HttpClient);
  private readonly trustedServerUrls = [
    "http://localhost:8081",
    "https://schemas-service.development.s1seven.com",
    "https://schemas-service.staging.s1seven.com",
    "https://schemas-service.s1seven.com"
  ];
  // Regular expressions for dynamic server URL matching for Heroku review apps
  private readonly trustedServerPattern = /^https:\/\/s1-schemas(?:-service)?-[a-zA-Z0-9-]+\.herokuapp\.com[\/]?$/;

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
    const devUrl = "https://schemas-service.development.s1seven.com";
    let url = devUrl;

    try{
      const baseUrl = `${window.location.protocol}//${window.location.hostname}`;

      if(baseUrl.includes('localhost')) {
        url = `${baseUrl}:${window.location.port}`;
      }
      else {
        url = baseUrl;
      }

      // Check if the URL is explicitly trusted
      if (this.trustedServerUrls.includes(url)) {
        return url;
      }

      // Check if the URL matches the dynamic pattern
      if (this.trustedServerPattern.test(url)) {
        return url;
      }

    console.error(`Error: Couldn't find matching allowed url for ${baseUrl}`)
    return devUrl;
    }
    catch (e) {
      console.error("Error while creating serverUrl: ", e);
      return devUrl;
    }
  }
}
