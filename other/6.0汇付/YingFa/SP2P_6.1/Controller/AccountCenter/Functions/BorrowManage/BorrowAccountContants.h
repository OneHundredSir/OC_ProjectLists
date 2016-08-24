//
//  BorrowAccountContants.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#ifndef SP2P_6_1_BorrowAccountContants_h

#define SP2P_6_1_BorrowAccountContants_h

#define Borrow_State_Auditing 0 // 0.审核中;
#define Borrow_State_BeforeLoan 1 // 1.提前借款;
#define Borrow_State_Fundraising 2 // 2.筹款中(审核通过);
#define Borrow_State_WaitingLoan 3 // 3.待放款(放款审核通过);
#define Borrow_State_Repaying 4 // 4.还款中(财务放款);
#define Borrow_State_Repayed 5 // 5.已还款;
#define Borrow_State_AuditFail -1 // -1.审核不通过;
#define Borrow_State_LoanningFail -2 // -2.借款中不通过;
#define Borrow_State_LoanedFail -3 // -3.放款不通过;
#define Borrow_State_BadBids -4// -4.流标;
#define Borrow_State_Revocation -5 // -5.撤销

#endif
