# CryptoExchange

#### Team
**[김준건(Geon)](https://github.com/jgkim1008)** </br>
[**홍정아(Joey)**](https://github.com/joey-ful)


# Introduction

CryptocurrencyExchange는 **가상화폐의 가격정보**를 제공하는 iOS 앱입니다. 실시간로 업데이트되는 **현재가와 변동률**을 제공하며 가상화폐별로 상세한 **그래프, 체결내역, 호가**를 제공합니다. 데이터는 [**Upbit Rest API와 WebSocket 통신**](https://docs.upbit.com/docs/upbit-quotation-restful-api)으로부터 받아왔습니다.

- 메인화면 상단에 인기코인 10개를 배치해 **화두에 오른 코인을 빠르게 파악**할 수 있도록 했습니다.
- **SwiftUI로 구현한 미니 차트를 UIHostingController**를 통해서 **컬렉션뷰의 cell**에 녹여냈습니다.
- **MVVM을 구조를 적용**해 ViewController의 역할을 분리하고 코드의 결합도를 낮추었습니다.

---

# 사용한 기술

| UI | UIKit, SwiftUI(메인 그래프 UI) |
| --- | --- |
| 아키텍처 | MVVM |
| 저장소 | UserDefaults(관심 코인, APIKey) |
| 라이브러리 | SnapKit, Charts |
| Git브랜칭 전략 | Git-Flow 전략 (main, develop, feature 브랜치 사용) |
| 협업 방식 | 각자 브랜치를 맡아 구현 후 PR을 올리면 상대방이 확인 후 머지 |

---

# 목록
1. [구현 화면](#구현-화면)
2. [구현 사항](#구현-사항)
3. [Main Features](#main-features)
4. [핵심경험](#핵심경험)

---

# 구현 화면

### 탭바 (메인 ↔ 입출금)

|**`메인` - 코인 실거래가 & 인기**|**`메인` - 관심목록**|**`입출금 현황`**|
|-|-|-|
|<img src="https://user-images.githubusercontent.com/52592748/154059379-971fcaa7-7473-497d-af6e-9147d1716829.gif" width="250"/>|<img src="https://user-images.githubusercontent.com/52592748/154059378-04fd97e5-a15d-4346-a868-c0a4f26f158e.gif" width="250"/>|<img src="https://user-images.githubusercontent.com/52592748/154059373-df017fde-3875-4804-a437-5473daa0b41e.gif" width="250"/>|

### 상세화면 (차트 ↔  호가 ↔  시세)

|**`상세` - 코인 실거래가 그래프**|**`상세` - 호가정보창**|**`상세` - 체결내역**|
|-|-|-|
|<img src="https://user-images.githubusercontent.com/52592748/154059370-a1760939-1168-449b-9a59-43d673343b19.gif" width="250"/>|<img src="https://user-images.githubusercontent.com/52592748/154059369-522eb9d9-fbbb-4d14-a75f-ec4f9de32b27.gif" width="250"/>|<img src="https://user-images.githubusercontent.com/52592748/154059365-6f9d3a0d-ae2c-4a1f-b733-9a86854c07c5.gif" width="250"/>|

---

# 구현 사항

**메인 화면**

- 화면 상단에 **인기 가상화폐 10개**를 표시했습니다.
- 가상화폐의 **현재가, 변동률, 거래금액을 리스트로** 표시했습니다.
- 리스트에 **관심목록**을 표시했습니다. 관심코인은 **UserDefaults**로 관리했습니다.
- **서치바**로 원하는 가상화폐를 빠르게 찾을 수 있게 했습니다.
- **자산명/현재가/변동률/거래금액** 기준으로 양방향 **정렬 기능**을 구현했습니다.

**상세 화면**
- 가상화폐 선택시 상세 화면으로 이동하며, 상세 화면 상단에 **현재가와 변동률**을 표시했습니다.
- 하단에는 **그래프/호가/체결내역** 화면을 선택해 볼 수 있도록 했습니다.
  - 그래프 화면에서 **1분/10분/30분/1시간/일 그래프**를 표시했습니다.
  - 호가 화면에서 리스트에 **실시간으로 업데이트되는 매수/매도**가를 표시했습니다.
  - 체결 화면에서 **체결내역을 리스트**로 표시해 **실시간으로 업데이트**했습니다. 일별 체결내역을 선택해서 볼 수 있습니다.

**입출금현황 화면**
- **가상화폐들의 입/출금 현황 정보**를 표시했습니다.
- **서치바**로 원하는 코인을 빠르게 찾을 수 있게 했습니다.

---

# Main Features

### 인기코인만 따로 모아 한 눈에
|||
|--|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059359-2101b52f-67e5-4119-bb32-d0bf18a3198a.gif" width="250" /></div>|1️⃣  화면 상단에 **최근 24시간 인기 코인 10**개를 나타냅니다. </br>2️⃣  SwiftUI로 구현된 미니 차트를 [**UIHostingController**](#uihostingcontroller)로 컬렉션뷰에 넣었습니다.|

### 실시간으로 업데이트되는 가상화폐 목록 확인
|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059354-e1c1f0f3-aae0-47cb-93d1-75444bf6f47b.gif" width="250"/></div>|1️⃣  WebSocket을 이용해 가상화폐의 **실시간 가격정보**를 가져오고 **DiffableDataSource를** 통해 이를 반영했습니다. </br> 2️⃣  **현재가 업데이트시 셀이 깜빡**입니다. </br> 3️⃣  **각 항목마다 양방향 정렬**을 제공합니다.

### 서치바로 원하는 코인을 빠르게 검색
|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059353-0580f4db-61b1-4714-ab84-b0586f0eb23c.gif" width="250"/></div>|1️⃣  **서치바**로 가상화폐의 이름과 심볼을 검색할 수 있습니다. </br> 2️⃣  검색 키워드를 **감지**하면 **검색 결과를 DiffableDataSource를 통해 실시간**으로 보여줍니다.|

### 관심코인 기능으로 원하는 코인만 모아보기

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059342-74c2bc1c-e3f3-4291-b0be-e20ecca6d8c1.gif" width="250"/> </div>| 1️⃣  **관심 코인을 등록/해제**할 수 있고 이를 [**UserDefaults**](#관심-코인-및-apikey를-관리하는-userdefaults)에서 관리합니다. </br> 3️⃣  메인화면의 관심 목록에서 **관심코인들만 모아** 볼 수 있습니다.|

### 코인의 상세화면에서 차트/호가/시세를 빠르게 파악

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059336-e23ba1e1-7af0-4e2e-a86f-ca5c34eb12ca.gif" width="250"/></div>| 1️⃣  코인의 상세화면마다 **실시간 현재가와 변동률**을 보여줍니다. </br> 2️⃣  코인별로 **차트/호가/시세 화면을 UISegmentedControl**를 통해 제공합니다.|

### 여러 가지 차트로 다양한 가격흐름을 파악

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059335-af577229-f168-4315-892e-67cd8ef2204b.gif" width="250"/></div>|1️⃣  **1분/10분/30분/1시간/일** 차트를 제공합니다. </br> 2️⃣  **캔들 차트**로 시가, 종가, 고가, 저가를 표현합니다. </br> 3️⃣  시가와 종가의 평균을 나타내는 **라인 차트**를 제공합니다. </br> 4️⃣  거래량을 나타내는 **바차트**를 제공합니다. </br> 5️⃣  **줌과 스크롤 기능**을 제공합니다.|

### 코인의 가격흐름을 표로 확인

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059332-93c0182a-5bf0-445f-8fe6-b5fbe79c6328.gif" width="250"/></div>|1️⃣  **시간별** 시세창에서 **실시간으로 체결되는 현재가**를 나타냅니다. </br> 2️⃣  **일별** 시세창에서 **매일매일의 종가와 변동률**을 나타냅니다. </br> 3️⃣  **UISegmentedControl**로 **시간별/일별** 뷰를 선택할 수 있습니다.|

### 실시간 매수/매도가와 그 비율을 한눈에 파악

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059326-00f83679-ce41-49b8-9828-f1c126bceaae.gif" width="250"/></div>|1️⃣  **매수/매도가가 색으로 분리**되어 나타나며 **실시간으로 업데이트**됩니다. </br> 2️⃣  매수/매도가의 **양을 색깔bar**로 나타냅니다. |

### 탭바로 거래소와 입출금현황 화면이동을 쉽게

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154059318-21e45ba0-838b-4fe5-a8f9-d4e89b5a31e1.gif" width="250"/></div>|1️⃣  거래소와 입출금현황을 탭을 통해 빠르게 이동할 수 있습니다.|

---

### 다양한 화면 크기에 대응할 수 있는 UI

|||
|-|-|
|<div style="width:250px"><img src="https://user-images.githubusercontent.com/52592748/154061767-75351d3b-5730-4bf8-8f87-4d5ae29a5704.gif" width="250"/></div>|1️⃣  AutoLayout으로  고정값이 아닌 **비율로 설정**하여 **다양한 기기에 대응**할수 있도록 설정하였습니다.|

-----------------------------

# 핵심경험
## JWT 토큰 만들기
업비트의 경우 입출금 현황을 RestAPI로 요청할 때 인증을 해야만 데이터를 가져올 수 있습니다.
JWT 토큰을 생성하기 위해 header, payload, signature 이렇게 3가지를 생성했습니다.
header와 payload는 Base64 SafeURL 방식으로 인코딩했습니다. 그 둘을 privateKey를 이용해 CryptoKit의 SHA256 방식으로 암호화해 JWT 토큰을 생성했습니다.
PublicKey와 JWT 토큰을 URLRequest의 Header에 담아서 전송했습니다.

</br>

## UIKit + MVVM

기존 MVC 패턴대로 진행하는데다 CodeBase로 UI를 작성하다보니 `ViewController`가 방대해지는 문제가 발생했습니다. 또한 뷰와 데이터 관련 로직들의 결합도가 높아지는 문제도 발생해 이를 해결하고자 MVVM 패턴을 도입했습니다.

<img src="https://user-images.githubusercontent.com/52592748/154061151-08679dca-e62f-4b5a-b7ca-0ea3743fcf7b.png" width="700"/>

#### ViewController는 뷰만 관리

데이터는 `ViewModel`로부터 전달받고 데이터의 변경 시점은 **Notification**으로 받습니다. `ViewModel`을 외부에서 주입받아 결합도를 낮췄습니다.

#### 데이터를 제공하는 ViewModel, 데이터를 사용하는 View

`ViewModel`은 `Service`로 데이터를 받은 뒤 `View`에서 원하는 형태로 데이터를 가공합니다. 데이터가 변경되면 **Notification**을 보냅니다.

`View`는 `ViewModel`로부터 데이터를 꺼내 **별다른 가공없이 그대로** 사용합니다. 

</br>

## DispatchGroup

#### 문제사항
Combined Chart에 들어가는 candleData, barData, lineData 를 생성해줄 때 main 스레드에서 동기적으로 생성하게 되다보니 시간이 오래걸렸습니다. 그러다 보니 차트를 보여주는 ViewController가 보여지는데 시간이 오래걸리는 문제가 발생하였습니다.


#### DispatchGroup을 통한 해결방법
DispatchGroup 을 사용하여 각기 다른 thread에서 동작하게 하고 완료됬을때 ViewController에게 노티를 보내어 main Thread에서 UI를 그리게 하면 좀더 빠르게 동작할것이라고 생각하였습니다.

DispatchGroup를 적용할떄 DispatchGroup 내부에 들어가는 함수가 동기적이냐 비동기적이냐를 확인했어야 했습니다. 내부에 비동기 함수가 들어갈경우 `enter()` 및 `leave()` 메서드를 통해 시작과 끝을 알려야 했지만 `candleData, barData, lineData`를 만드는 로직은 동기적 함수이기에 DispathGroup에 넣어주기만 했습니다. 그리고 모든 데이터 준비 작업이 끝나는 시점을 `notify()`해 ViewController가 Combined Chart를 한 번에 그릴 수 있게 구현했습니다.

</br>

## 관심 코인 및 APIKey를 관리하는 UserDefaults

#### 앱이 종료되어도 유지되는 사용자 기본 설정
UserDefaults는 사용자의 기본 설정과 같은 단일 데이터 값을 설정하는데 적합합니다.
따라서 관심 코인들을 UserDefaults에 저장해 관리했습니다. 관심이 해제되면 UserDefaults에서 제거했습니다.
관심목록이나 코인의 관심여부 UI를 표현하기 전 매번 UserDefaults를 확인했습니다.

#### APIKey의 비밀키는 .gitignore에 추가해 보관
업비트의 APIKey로 공개키, 비밀키 한 쌍이 주어지며 이 중 비밀키를 안전하게 보관해야 합니다. Property list 파일에 APIKey를 저장하고 해당 파일을 .gitignore에 추가하여 git에 올라가지 않도록 설정하였습니다.

</br>

## Git-Flow 브랜칭 전략

`Git-Flow` 브랜칭 전략을 사용해 **원활한 협업**을 취하고자 했습니다. 프로젝트의 규모와 팀 규모가 크지 않아 `main`, `develop`, `feature` 브랜치 개념만 도입한 간소화된 Git-Flow 전략을 택했습니다.

<img src="https://user-images.githubusercontent.com/52592748/154061336-8c087d63-e2a5-440a-95bf-e4ddf50fd48b.png" width="700"/>

#### 당장 배포가 가능한 `main` 브랜치

배포 가능한 기능이 모두 완료된 상태를 유지하도록 했습니다.

#### 다음 배포 버전을 위한 `develop` 브랜치

배포 버전이 완성될 때까지의 모든 `feature` 브랜치를 머지하는 용도로 사용했습니다. 프로젝트 진행 과정 중 모든 `feature` 브랜치의 PR은 `develop` 브랜치에 요청했습니다.

#### 기능별로 생성하는 `feature` 브랜치

협업 과정에서 **충돌을 최소화**하고자 개인별로 **특정한 기능을 맡아 구현**했습니다. 

어떠한 기능을 맡았는지 알아보기 쉽도록 `feature_기능` 혹은 `feature_화면_기능` 으로 브랜치명을 작성하는 규칙을 지켰습니다.

- 개인당 **한번에 하나의** `feature` 브랜치만 맡아 구현했습니다.
- **충돌을 최소화**하기 위해 하나의 브랜치에는 관련된 기능들만 구현해 단위를 최소화했고, **총 30개의 PR 요청이 머지**되었습니다.
- 각 **PR은 상대 팀원이 머지**해 서로의 구현사항을 파악할 수 있도록 했습니다.


![Untitled](https://user-images.githubusercontent.com/52592748/154061332-d071ddf7-f003-42fb-81c0-9922ef437ef5.png)

</br>

## UIHostingController
인기코인의 미니 그래프를 SwiftUI로 구현하여 `UIHostingController` 를 활용해 컬렉션뷰의 셀에 추가했습니다.

```swift
var hostingVC: UIHostingController = {
    return UIHostingController(rootView: MiniChart())
}()

addSubView(hostingVC.view)
addChild(hostingVC)
hostingVC.didMove(toParent: self)
```

</br>

## 빌드 및 실행 속도를 향상시키기 위한 CodeBased UI

화면이 많고 각 화면에 들어가는 정보가 많다고 생각해 스토리보드를 사용하면 프로젝트가 무거워질 것이라 생각했습니다. 더욱 빠르게 실행하기 위해 UI를 모두 코드로 작성했습니다.

#### 중복작업을 최소화

특정 크기나 폰트 등을 프로퍼티로 저장해 해당 프로퍼티를 사용하도록 구현했습니다. 인터페이스에서 직접 선택하는 것보다 중복 작업을 줄일 수 있을 것이라 판단했습니다.

#### SnapKit 라이브러리 사용으로 코드 최소화

인터페이스 구현에 비해 코드 양이 많아지는 단점을 보완하기 위해 스냅킷 라이브러리를 활용했습니다. SnapKit으로 오토레이아웃 코드를 훨씬 간결하고 빠르게 작성해 CodeBasedUI의 단점을 최소화하고자 했습니다.
