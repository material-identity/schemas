import {
  ChangeDetectionStrategy,
  Component,
  ElementRef,
  ViewChild,
  effect,
  signal,
} from '@angular/core';
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
      class="flex flex-col rounded-md border border-slate-200 select-none"
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

      <!-- <div class="p-4 h-60 overflow-hidden">
        <pre class="text-xs opacity-50"><code>{{ jsonPreview() }}</code></pre>
      </div>
      <div
        class="bt-1 text-sm text-center py-4 text-gray-800 justify-center items-center flex gap-1"
      >
        <mat-icon inline fontIcon="arrow_circle_up"></mat-icon>
        Drag Certificate JSON here
      </div> -->
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UploaderComponent {
  @ViewChild('fileInput') fileInput?: ElementRef<HTMLInputElement>;
  readonly file = signal<File | null>(null);

  constructor() {
    effect(() => {
      if (this.file()) return;
      if (!this.fileInput) return;
      this.fileInput.nativeElement.value = '';
    });
  }

  onFileSelected(event: any): void {
    const file: File = event.target.files[0];
    // Do something with the selected file
    console.log(file);
    this.file.set(file);
  }

  onFileDrop(event: DragEvent): void {
    event.preventDefault();
    const files = event.dataTransfer?.files;
    if (files && files.length > 0) {
      const file: File = files[0];
      // Do something with the dropped file
      console.log(file);
    }
  }

  onDragOver(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    // event.dataTransfer?.dropEffect = 'copy';
    // Add CSS class to indicate drag over
    // event.target['classList'].add('drag-over');
  }

  onDragLeave(event: DragEvent): void {
    event.preventDefault();
    event.stopPropagation();
    // Remove CSS class when dragging leaves the drop zone
    // event.target['classList'].remove('drag-over');
  }
}
