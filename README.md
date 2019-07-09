# JSON 문자열 분석기
---
## 객체 한줄 요약
- `GrammerChecker`: 입력받은 문자열에 대해 검증을 하는 객체
    - `Pattern`: `jsonObject,jsonList` 포맷을 확인하기 위한 내부적으로 **재귀**적으로 **정규표현식패턴**을 만들어내는 객체
- `MyTokenizer` : 문자열을 토큰화하는 객체
     - `Token`: 의미를 가진 가장 작은 단위 (단말) `enum`객체
        - ` ex) 문자열,숫자,부울,공백,[,]{,},\,,...`
    - `TokenFactory`: 잘게 쪼개진 문자열로 의미를 표현할수 있는 `Token`를 생성하는 팩토리객체
- `MyParser` : `[Token]`의 배열을 `JsonList,JsonObject`로 변환해주는 객체
  - `JsonList, JsonObject`: swift 기본 콜렉션 자료구조에 `JsonValue`프로토콜을 채택하여 확장한 타입

- `InputView`: 사용자에게 분석할 문자열을 입력받는 뷰 객체
- `OutputView`: 파싱된 JSON에 대한 통계분석을 출력하는  뷰 객체 
---

### 프로젝트를 진행하면서 느낀점

처음시작이 너무 막막했었다.  
`문자열은 말 그대로 문자열인데 이것을 어떻게 의미를 부여할까?` 에 대해 처음 고민을 했다.
그리고 사람은 
```
[ { "name": "부엉이" , "favorites" : [ "샌드위치", "커피"  ], "famous" : "Hello, World" } ]
```
 이런 문자열을 어떻게 쉽게 인식하는 지 에 대해 고민을 했다.
그러던 중 `"Hello, World"` 문자열로 인식하던 이유는 `,` 가 내가 분석 중인 **Context**에 따라 사람은 쉽게 다르게 인식한다는 것이었다.  
나는 분석중인 `Context`라는 키워드에 집중하기로 했고,
`Context`와 `Stack`의 조합으로 하나의 `Parser` 를 만들어 내기위한 시도를 하였다.
컴파일러의 원리를 공부하게 되었다.
컴파일러는 3가지 단계로 나뉘어진다.  
`Code` - **`Lexer`** -> `Token` -  **`Parser`** -> `AST` - **`CodeGenerator`** -> `Machine Code`

나는 `Lexer` 가 하는 일을 자세히는 알지 못했다.
하지만 목적은 알고 있었다. 어쨋든 의미를 가진 작은 단위로 쪼개는 토큰화라는 걸 하는 객체라는 것을 알게 되었고, 객체가 해야할 일과 기대하는 동작이 명확해 지는 걸 느꼈고
```swift
    MyTokenizer.tokenize(_ :String ) -> [Token]
```
 이것이 곧 **인터페이스**라는 걸 느꼇다.
그래서 인터페이스를 기반으로 테스트 코드를 작성하기 시작했다.

이 같은 과정으로 **객체가 있는 목적에 따른 인터페이스를 분리**했고,
인터페이스가 되는 메소드들을 **테스트 하기위한 입력과 기대하는 출력을 정리하여, 테스트 코드를 작성**했고, 그 결과 `private` 할 것과 `public` 할 것이 명확히 나뉘어지는 것 같아서 즐거움을 느꼈다.
객체가 내가 원하는 대로 동작을 하게되어 테스트가 이쁜 초록색 체크✅ 를 하며 
통과를 할 때 희열을 느꼈다.


![jsontest](https://user-images.githubusercontent.com/39197978/60900699-95531900-a2a7-11e9-96e5-b64aaae59330.gif)

**TDD**의 맛보기를 본 느낌이었지만, TDD가 이런 이유로 개발에 이 점을 줄 수 있는 걸 느껴보는 좋은 경험 이었다.

`Parser`를 진행할 때 다시 다른 방식도 고민해보았다.


<img width="657" alt="스크린샷 2019-07-09 오후 10 42 19" src="https://user-images.githubusercontent.com/39197978/60892888-db55b000-a29a-11e9-8541-eb543a0a1b79.png">

`value`에는 `array, object`로 표현될 수 있는 데 , 
또  `array, object`는 `value`를 포함하는 **사이클구조**였다.

 밖에서 부터 분석을 하며, 새로운 분석객체(`JSONList[],JSONObject{}`)를 만났을 때 재귀적으로 다시 분석을 시작 함으로써, 스택과 유사한 방식으로 분석을 할 수 있다는 것을 느꼈다.

또 ! `JSONList[],JSONObject{}` 각각의 문법 규칙이 달라서 분석의 차이가 있었다.
<img width="668" alt="스크린샷 2019-07-09 오후 10 42 00" src="https://user-images.githubusercontent.com/39197978/60892886-dabd1980-a29a-11e9-9929-48aaa7ad01aa.png">
<img width="653" alt="스크린샷 2019-07-09 오후 10 42 06" src="https://user-images.githubusercontent.com/39197978/60892887-dabd1980-a29a-11e9-92fa-3d8cd41ccb78.png">

두개의 분석방식을 적절히 스위칭하며 분석을 하고자 하였어서 `스트래티지패턴`이라는 것도 적용 해봤다.
**스트래티지**를  선택하는 근거(?)는 토큰이 `"[,{"` 같은 분석의 시작점을 통해 결정되게 하였다.

이 것이 복잡하게 되어있으면, `컴파일러의 파싱트리(파싱테이블) 과 유사한 형태를 띄게 되지 않을까?` 라는 상상도 하게 되었다.

마지막에 `swift`자료구조의형태로 파싱된 `JSON`데이터들을 출력하는 과제가 남아있었다.

**객체(JSONList,JSONObject) 각각이 자신의 포맷을 결정**하게 끔하여 **다형메소드**로 구현하는 방법이 있었고, 


입력된 객체에 따른 형식화를 해주는 별도의 객체(Formatter)를 두는 방법이 있었다.

클린코드의 책을 빌리자면 두개는 상황에 따라 다르다고 한다.
**타입이 계속적인 추가가 있을 형태라면?** 그마다 형식화를 하는 객체의 `switch문`은 고장날 것이고, 커질 것이라는 것이다. 이럴 떄는 **다형메소드가 더 좋은 방법**일 것이다.


### 하지만
 **타입보다는 메소드가 추가된다면 모든 객체에 다형메소드가 하나씩 추가되어야 하기때문에** 하나의 `switch문`만 더 추가로 구현하면 되는 
 **여러 객체를 다루는 별도의 객체가 있는 것**이 좋을 것이라는 것을 생각하게 되었고, 프로젝트는 마무리 되었다!! 



## 실행영상
---

![jsonParser](https://user-images.githubusercontent.com/39197978/60900697-94ba8280-a2a7-11e9-8982-5b69eca5b714.gif)
