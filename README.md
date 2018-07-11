# MakeHabit
Go AppStore!!


V1.0 
---

- 목표
	- App Store A to Z 경험을 목표로!.
	- ' 이게 아닌가?' -> '한번 기획된 목표는 불도져러럼 완성시켜라'
	- Realm 을 활용한 Todo + Reminder App


- 회고
	- MVC를 지키기 힘들다....역시나..
	- Model과 Manager의 차이가 있는 API 만들기는 언제나 햇갈린다.
	- Refactoring을 진행하자! ( RxSwift + Bad Smell 없애기)

v1.2
---

- 목표
	- RxSwift를 사용해서 ChartManager, HabitManager의 리펙토링 ㄱ ㄱ
	- TodayExtension을 통해 현재 등록한 습관중 하나를 위젯으로 볼수있게 변경	- 주석 모두 작성하기!

- V 1.2 개발 일기
----

### Day 1

- API 와 Model의 구분을 다시.. 합칠건 합치고, 없앨건 없애야함.
	- Struct 값 타입으로 변화 할것은 바꾸고..

- ChartManager
	- makePieChart 
		- HabitManager를 인자로 받고 completion Handler로 차트를 반환함.
	- getCurrentCountDataBase
		- indexPath를 받아서 .. 이건 안씀. 현재 완료안된 습관을 불러오려 했던것 같음

- HabitManager, persist Realm 객체를 관리
	- add
		- Realm에 값 추가.
	- getRealmObjectList
		- 필터를 걸어서 이에 해당되는 모든 필터의 정렬 반한값. , 정렬 안하는 함수도 있는데 그때 이걸 왜 나눴지?
	- updateSucessPromiss
		- 성공한 습관의 successPromiss 필드의 값을 트루로 변경
	- alarmTimeConvertSecond
		- 이건 아마 Local Push 하는 방법을 바꿔서 안쓰는걸로..
	- getScheduledDay
		- 날로 바꿔서 시작날과 종료일에 대한 차이 값을 반환
	- shouldPerFormAppendDatePromissList
		- 목표일수에 대한 Realm의 데이터를 관리 하는건데.. 켈린더를 눌렀을때 목표일과 수행일에 대한 정보가 발생 하는 문제로 여기서 Realm의 해당 습관의 데이터를 App에서 현재 누른 정보를 기준으로 재생성해야된다..
	- safeWrite
		- 이건 .. 습관 캘린더에 날짜 확인 후 디스미스될떄 값 저장 문제떄문에 만든것으로 기억함.. 없애도 될듯
		
- UserInfoType, 사용자 정보 persist Realm 객체. 사실상 alarmNeeded 정보 빼고는 크게 필요 없는 필드들..
	- didChangedAlarmValue
		- 사용자 닉네임 변경, 알람 설정 여부에 대한 Realm 쓰기 메소드.
	- setUserNickName
		- 사용자 닉네임 쓰기 하는거 .. 이것도 굳이 위에거랑 중복인것 같음.
	- getRealmObjectList
		- 이것 어딘가에 중복됬었던걸로 기억.

- Util , 일단 이걸 쪼갤거임.. 의미 없이 그냥 잡동사니 처박아 논 느낌이라.
	- toNotifyUserAlert
		- title, mesaage들을 인자로 받아 completion핸들러를 통해 확인 눌른 이후의 액션을 정할 수 있게끔 구현
	- performActionAfterAlert
		- 알랏 띄워주는 .. 위와 동일하게 인자를 받는다.
	- calculateTotalDate
		- 입력 달에 대해 총 일수를 반환 해줌.
	- convertTo24Hour
		- AM/PM 표기를 24시간 표기로 변환
	- timedNotification
		- LocalPush 메소드
	- userInputAlert
		- App의 처음 실행일때 (Realm의 UserInfo 를 보고 판단) 사용자 닉네임을 넣어 주도록 변환.

> 일단 첫번째로 명령형 패러다임으로 짰었던 기존 모델과 aPI 들을 걷어내는 작업을 먼저 할거임...
> 
> 두번째로 Realm의 persist 객체를 하나로 변경.
	
	
	
	
	
	