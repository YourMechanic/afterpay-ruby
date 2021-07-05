## [Unreleased]

## [2.0.0] - 2021-06-02

- Initial release

### 2.0.1 - 2021-07-05

* bug fixes
  * Correct the from_response method by not directly calling new with response but formatting the amount and then calling new with the attributes. The afterpay-sdk gem follows the Data Models attibutes data types as in v2 doc. As per the doc amount attibute of Refund or PaymentEvent object is a Money object so when the developer calls new he need to supply the money object however we use from_response method where we convert amount in response to money object using utils. (by @sachinsaxena1996)
  * Fix refund objects attributes. add sucess? to refund model. Fix id be string in PaymentEvent. (by @sachinsaxena1996)
  * Do not directly call new with response.body use from_response instead. Change done as attribute were blank in Refund.execute. (by @sachinsaxena1996)
  * Fixed issue with error object of Refund object (by @sachinsaxena1996)
* enhancement
  * respond with objects array in payment response objects for events and refunds attributes. (by @sachinsaxena1996)
  * Added rspec for data models (by @sachinsaxena1996)

