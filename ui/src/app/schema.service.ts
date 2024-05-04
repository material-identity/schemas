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
    const url = 'http://localhost:8080/api/render';
    const res = await firstValueFrom(
      this.http.post(url, certificate, {
        params: {
          schemaType,
          schemaVersion,
          languages,
        },
      })
    );
    console.log({ res });
  }
}
