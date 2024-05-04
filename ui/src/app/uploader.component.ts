import {
  ChangeDetectionStrategy,
  Component,
  ElementRef,
  ViewChild,
  effect,
  signal,
} from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-uploader',
  standalone: true,
  imports: [MatIconModule, MatButtonModule],
  template: `
    <div
      (drop)="onFileDrop($event)"
      (dragover)="onDragOver($event)"
      (dragleave)="onDragLeave($event)"
      class="flex flex-col rounded-md border border-slate-200 select-none ring-primary-500"
      [class.ring]="dragging()"
    >
      <input
        class="hidden"
        type="file"
        (change)="onFileSelected($event)"
        accept=".json"
        #fileInput
      />
      @if (!file()) {
      <div class="flex justify-between items-center p-4 pl-2">
        <button mat-stroked-button (click)="fileInput.click()">
          Select JSON File
        </button>

        <span class="text-gray-700 text-sm">Drop file here to upload</span>
      </div>
      } @else {
      <div class="flex gap-2 items-center p-2">
        <mat-icon fontIcon="text_snippet">description</mat-icon>
        <span class="text-gray-800 flex-1">{{ file()?.name }}</span>
        <button mat-icon-button (click)="file.set(null)">
          <mat-icon>close</mat-icon>
        </button>
      </div>
      }
    </div>
  `,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: UploaderComponent,
      multi: true,
    },
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UploaderComponent implements ControlValueAccessor {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  readonly file = signal<File | null>(null);
  readonly dragging = signal<boolean>(false);

  private onChange = (file: File | null) => {};
  private onTouched = () => {};

  constructor() {
    effect(() => {
      if (this.file()) return;
      if (!this.fileInput) return;
      this.fileInput.nativeElement.value = '';
      this.onChange(null);
      this.onTouched();
    });
  }

  onFileSelected(event: any): void {
    const file: File = event.target.files[0];
    this.file.set(file);
    this.onChange(file);
    this.onTouched();
  }

  onFileDrop(event: DragEvent): void {
    event.preventDefault();
    const files = event.dataTransfer?.files;
    if (files && files.length > 0) {
      const file: File = files[0];
      this.file.set(file);
      this.onChange(file);
      this.onTouched();
    }
    this.dragging.set(false);
  }

  onDragOver(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.dragging.set(true);
  }

  onDragLeave(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    this.dragging.set(false);
  }

  writeValue(file: File | null): void {
    this.file.set(file);
  }

  registerOnChange(fn: (file: File | null) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }
}
