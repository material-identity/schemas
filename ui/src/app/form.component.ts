import {
  ChangeDetectionStrategy,
  Component,
  HostBinding,
  computed,
  inject,
  signal,
} from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatRadioModule } from '@angular/material/radio';
import { MatChipsModule } from '@angular/material/chips';
import { UploaderComponent } from './uploader.component';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatIconModule } from '@angular/material/icon';
import { SchemaService } from './schema.service';
import { FormControl, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-form',
  standalone: true,
  imports: [
    MatButtonModule,
    MatRadioModule,
    MatChipsModule,
    UploaderComponent,
    MatCheckboxModule,
    MatIconModule,
    ReactiveFormsModule,
  ],
  template: `
    <section>
      <strong class="text-gray-900">Certificate</strong>
      <p class="text-gray-700 mb-4 text-sm">
        Upload the certificate you would like to validate or create the PDF of.
      </p>
      <app-uploader [formControl]="certificateControl"></app-uploader>
    </section>
    <section>
      <strong class="text-gray-900">Schema</strong>
      <p class="text-gray-700 mb-4 text-sm">
        Select a schema for validation. Schemas are maintained by
        <a class="underline" taget="_blank" href="https://materialidentity.org/"
          >Material Identity</a
        >.
      </p>

      <mat-radio-group
        class="rounded-md border border-slate-200 block px-2 py-4"
      >
        <div class="grid grid-cols-4">
          @for (schema of visibleSchemaVersions(); track schema[0]) {
          <div class="flex flex-col">
            <span
              class="ml-[var(--mdc-radio-state-layer-size)] text-sm text-gray-700 mb-2"
              >{{ schema[0] }}</span
            >
            @for (version of schema[1]; track version) {
            <mat-radio-button
              class="example-radio-button"
              [value]="schema[0] + '.' + version"
              >{{ version }}</mat-radio-button
            >
            }
          </div>
          }
        </div>
      </mat-radio-group>
    </section>
    <section>
      <strong class="text-gray-900">Languages</strong>
      <p class="text-gray-700 mb-4 text-sm">
        Select up to two languages for the PDF generation.
      </p>
      <div
        class="grid grid-cols-4 rounded-md border border-slate-200 px-2 py-4"
      >
        <mat-checkbox>English</mat-checkbox>
        <mat-checkbox>German</mat-checkbox>
        <mat-checkbox>Chinese</mat-checkbox>
      </div>
    </section>

    <span class="flex-1"></span>

    <div class="flex gap-2 justify-start">
      <button mat-raised-button color="primary">
        <mat-icon>verified</mat-icon>
        Validate
      </button>
      <button mat-stroked-button color="primary" (click)="render()">
        <mat-icon>picture_as_pdf</mat-icon>
        Generate PDF
      </button>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class FormComponent {
  @HostBinding('class') class = 'flex flex-col gap-8';
  readonly schemaVersions = signal<[string, string[]][]>([
    ['CoA', ['1.0.0']],
    ['TRK', ['1.0.0', '1.2.0']],
    ['EN10168', ['1.0.0', '1.2.0']],
    ['EN10168', ['1.0.0', '1.2.0']],
  ]);
  readonly showAllVersions = signal(true);
  readonly visibleSchemaVersions = computed<[string, string[]][]>(() =>
    this.showAllVersions()
      ? this.schemaVersions()
      : this.schemaVersions().map(([schema, versions]) => [
          schema,
          versions.slice(0, 1),
        ])
  );

  readonly certificateControl = new FormControl<File | null>(null);

  private readonly schemaService = inject(SchemaService);

  render() {
    const file = this.certificateControl.value;
    if (!file) return;
    const reader = new FileReader();

    reader.onload = (e: any) => {
      const text = e.target.result; // This is the content of the file as a string
      console.log('File content:', text, JSON.parse(text));
      const certificate = JSON.parse(text);
      this.schemaService.render(certificate);
    };

    reader.onerror = () => {
      console.error('There was an error reading the file:', reader.error);
    };

    reader.readAsText(file); // Read the file as text

    console.log(file);
    // Record<string, unknown>
  }
}