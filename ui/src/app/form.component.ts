import {
  ChangeDetectionStrategy,
  Component,
  HostBinding,
  computed,
  signal,
} from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatRadioModule } from '@angular/material/radio';
import { MatChipsModule } from '@angular/material/chips';
import { UploaderComponent } from './uploader.component';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatIconModule } from '@angular/material/icon';

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
  ],
  template: `
    <section>
      <strong class="text-gray-900">Certificate</strong>
      <p class="text-gray-700 mb-4 text-sm">
        Upload the certificate you would like to validate or create the PDF of.
      </p>
      <app-uploader></app-uploader>
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
        class="grid grid-cols-4 rounded-md border border-slate-200 block px-2 py-4"
      >
        <mat-checkbox formControlName="pepperoni">English</mat-checkbox>
        <mat-checkbox formControlName="pepperoni">German</mat-checkbox>
        <mat-checkbox formControlName="pepperoni">Chinese</mat-checkbox>
      </div>
    </section>

    <span class="flex-1"></span>

    <div class="flex gap-2 justify-start">
      <button mat-raised-button color="primary">
        <mat-icon>verified</mat-icon>
        Validate
      </button>
      <button mat-stroked-button color="primary">
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
}
