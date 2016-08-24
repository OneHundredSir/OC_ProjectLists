//
//  JXdetail.h
//  Flower
//
//  Created by maShaiLi on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Skulist,Speclist,Sku;
@interface JXdetail : NSObject



@property (nonatomic, copy) NSString *fnKolUserId;

@property (nonatomic, copy) NSString *fnSpec;

@property (nonatomic, copy) NSString *fnSecondEnTitle;

@property (nonatomic, assign) NSInteger fnReleaseStatus;

@property (nonatomic, assign) NSInteger fnAuditStatus;

@property (nonatomic, copy) NSString *fnThreeEnTitle;

@property (nonatomic, copy) NSString *fnAttachmentSnap;

@property (nonatomic, assign) NSInteger fnMarketPrice;

@property (nonatomic, copy) NSString *pItem;

@property (nonatomic, copy) NSString *fnName;

@property (nonatomic, copy) NSString *fnGoodsCode;

@property (nonatomic, copy) NSString *fnFirstDesc;

@property (nonatomic, copy) NSString *fnFourthTitle;

@property (nonatomic, assign) NSInteger fnInitClickNum;

@property (nonatomic, copy) NSString *fnEnName;

@property (nonatomic, copy) NSString *fnLastAdmin;

@property (nonatomic, copy) NSString *fnKeyWords;

@property (nonatomic, copy) NSString *uAddress;

@property (nonatomic, copy) NSString *fnMaterial;

@property (nonatomic, copy) NSString *fnMerchantsId;

@property (nonatomic, copy) NSString *fnAttachment;

@property (nonatomic, copy) NSString *fnFifthTitle;

@property (nonatomic, copy) NSString *fnThreeTitle;

@property (nonatomic, copy) NSString *fnAttachment1;

@property (nonatomic, assign) long long fnUpdateDate;

@property (nonatomic, assign) NSInteger fnAppointNum;

@property (nonatomic, copy) NSString *fnRecommendGoods;

@property (nonatomic, copy) NSString *themeName;

@property (nonatomic, assign) NSInteger fnSaleNum;

@property (nonatomic, assign) NSInteger fnIsSelectShipDate;

@property (nonatomic, copy) NSString *fnLimitArea;

@property (nonatomic, assign) NSInteger fnGoodsType;

@property (nonatomic, assign) NSInteger fnIsUseSpec;

@property (nonatomic, copy) NSString *fnFourthEnTitle;

@property (nonatomic, copy) NSString *fnItemId;

@property (nonatomic, strong) NSArray<Speclist *> *specList;

@property (nonatomic, assign) NSInteger leftNum;

@property (nonatomic, copy) NSString *fnStartSaleDate;

@property (nonatomic, copy) NSString *fnFirstTitle;

@property (nonatomic, copy) NSString *fnOnSaleDate;

@property (nonatomic, copy) NSString *recommendGoodsList;

@property (nonatomic, copy) NSString *fnFourthDesc;

@property (nonatomic, copy) NSString *fnId;

@property (nonatomic, copy) NSString *fnFifthEnTitle;

@property (nonatomic, copy) NSString *fnFifthDesc;

@property (nonatomic, copy) NSString *fnFirstEnTitle;

@property (nonatomic, assign) long long fnCreateDate;

@property (nonatomic, assign) NSInteger fnShareClickNum;

@property (nonatomic, assign) NSInteger fnSequence;

@property (nonatomic, copy) NSString *fnThreeDesc;

@property (nonatomic, copy) NSString *fnSecondTitle;

@property (nonatomic, copy) NSString *fnSecondDesc;

@property (nonatomic, copy) NSString *fnAttachmentSnap1;

@property (nonatomic, strong) NSArray<Skulist *> *skuList;

@property (nonatomic, assign) NSInteger fnAppClickNum;

@property (nonatomic, copy) NSString *fnEndSaleDate;

@property (nonatomic, assign) NSInteger fnReturnable;

@property (nonatomic, copy) NSString *fnAttachment2;

@property (nonatomic, copy) NSString *fnAttachmentSnap2;

@property (nonatomic, assign) NSInteger fnJian;

@property (nonatomic, copy) NSString *fnAdvImg;

@property (nonatomic, assign) NSInteger fnTotalNum;

@property (nonatomic, assign) NSInteger fnIsAddTheme;

@property (nonatomic, copy) NSString *fnAdvUrl;


@end


