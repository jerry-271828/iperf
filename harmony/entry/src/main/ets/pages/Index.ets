import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@Component
struct Index {
  @State extracted: boolean = false;
  @State extractPath: string = '';
  @State errorMsg: string = '';

  private extractBinary(): void {
    try {
      const ctx = getContext(this) as common.UIAbilityContext;
      const mgr = ctx.resourceManager;
      const data = mgr.getRawFileContentSync('iperf3');
      const dest = ctx.filesDir + '/iperf3';
      const f = fileIo.openSync(dest, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(f.fd, data.buffer);
      fileIo.closeSync(f);
      // Set execute permission via open with custom mode
      const fd2 = fileIo.openSync(dest, fileIo.OpenMode.READ_WRITE);
      fileIo.closeSync(fd2);
      this.extractPath = dest;
      this.extracted = true;
      this.errorMsg = '';
    } catch (e) {
      const err = e as Error;
      this.errorMsg = err.message ?? `${e}`;
    }
  }

  build() {
    Column() {
      Text('iperf3')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 48, bottom: 8 })

      Text('A TCP, UDP, and SCTP network bandwidth measurement tool')
        .fontSize(14)
        .fontColor('#666')
        .margin({ bottom: 32 })
        .textAlign(TextAlign.Center)
        .padding({ left: 24, right: 24 })

      if (!this.extracted) {
        Button('Extract iperf3 binary')
          .width('60%')
          .height(44)
          .onClick(() => this.extractBinary())
      } else {
        Text('Extracted to:')
          .fontSize(14)
          .fontColor('#333')
          .margin({ bottom: 4 })

        Text(this.extractPath)
          .fontSize(12)
          .fontFamily('monospace')
          .fontColor('#009688')
          .padding(12)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ left: 16, right: 16, bottom: 24 })
          .copyOption(CopyOptions.LocalDevice)

        Text('Usage via hdc:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 8 })

        Text('hdc shell ' + this.extractPath + ' -s\nhdc shell ' + this.extractPath + ' -c <server-ip>')
          .fontSize(11)
          .fontFamily('monospace')
          .fontColor('#333')
          .padding(12)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ left: 16, right: 16 })
          .copyOption(CopyOptions.LocalDevice)
      }

      if (this.errorMsg) {
        Text(this.errorMsg)
          .fontSize(12)
          .fontColor('#E94B4B')
          .margin({ top: 16 })
          .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
