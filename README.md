## 상세화면의 차트를 [캔들 차트]로 교체
- 기존에 SwiftUI로 그렸던 차트를 [Charts 라이브러리](https://github.com/danielgindi/Charts)로 그린 차트로 대체하였습니다.
- CombinedChart를 활용해 평균선과 캔들스틱을 함께 그렸습니다.
- 첫 로딩시 한 화면에 캔들스틱이 최근 30개 정도만 보이도록 zoom의 scale과 position을 조정했습니다.
- 차트를 확대/축소 할 수 있으며 스크롤로 이동할 수 있습니다.
<img src="https://user-images.githubusercontent.com/52592748/152804835-1d85ed3b-968a-4e30-8cf7-db07432abef8.gif" width="300" />
