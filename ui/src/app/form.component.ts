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
      <mat-checkbox [formControl]="attachJson">
        Attach DMP
      </mat-checkbox> 
    </section>
    <span class="flex-1"></span>
    <div class="flex gap-2 justify-start">
      <button mat-stroked-button color="primary" (click)="render()">
        <mat-icon>picture_as_pdf</mat-icon>
        Generate PDF
      </button>
    </div>
  `,
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class FormComponent {
  @HostBinding('class') class = 'flex flex-col gap-8';
  readonly certificateControl = new FormControl<File | null>(null);
  readonly attachJson = new FormControl<boolean>(true);
  private readonly schemaService = inject(SchemaService);

  render() {
    const file = this.certificateControl.value;
    const attachJson = this.attachJson.value ?? false;
    if (!file) return;
    const reader = new FileReader();

    reader.onload = (e: any) => {
      const text = e.target.result; // This is the content of the file as a string
      console.log('File content:', text, JSON.parse(text));
      const certificate = JSON.parse(text);
      this.schemaService.render(certificate, attachJson);
    };

    reader.onerror = () => {
      console.error('There was an error reading the file:', reader.error);
    };

    reader.readAsText(file); // Read the file as text

    console.log(file);
    // Record<string, unknown>
  }
}
