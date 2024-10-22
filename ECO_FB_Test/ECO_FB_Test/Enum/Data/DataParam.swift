//
//  DataInfo.swift
//  ECO_FB_Test
//
//  Created by Jaemin Hong on 10/11/24.
// 

import Foundation

enum DataParam {
    /**
     유저 조회가 필요할 때 사용
     */
    case userSearch(id: String)
    
    // Load(fetch) 작업이 필요하거나 id만 필요한 상황에 사용
    case userLoad(id: String, shouldReturnUser: Bool)
    case goodsLoad(id: String)
    case paymentInfoLoad(id: String)
    case cardInfoLoad(id: String)
    
    // Update(기존 데이터 갱신), Add(새로운 데이터 추가) 작업이 필요할 때 사용
    case userUpdate(id: String, user: User)
    case goodsUpdate(id: String, goods: Goods)
    case paymentInfoUpdate(id: String, paymentInfo: PaymentInfo)
    case cardInfoUpdate(id: String, cardInfo: CardInfo)
    case announcementUpdate(id: String, announcement: Announcement)
    case oneToOneInquiryUpdate(id: String, inquiry: OneToOneInquiry)
    
    case oneToOneInquiryDelete(id: String)
    
    // 모든 데이터를 불러올 때 사용
    /**
     물건을 모두 불러올 때 사용, 결과값은 GoodsStore의 goodsList에 저장됩니다.
     */
    case goodsAll(category: [GoodsCategory], limit: Int)
    /**
     결제정보를 모두 불러올 때 사용, 결과값은 PaymentInfoStore의 paymentInfoList에 저장됩니다.
     */
    case paymentInfoAll(userID: String)
    /**
     주문정보를 모두 불러올 때 사용, limit으로 불러올 데이터의 수를 제한 할 수 있으며, OrderDetailStore의 orderDetailList에 저장됩니다.
     
     제한된 수의 데이터를 불러오기 때문에 불러온 데이터를 모두 보여주었다면 다시 그 이후의 데이터를 더 불러와야 합니다.
     */
    case orderDetailAll(userID: String, limit: Int)
    /**
     공지사항을 모두 불러올 때 사용, 20개씩 불러오며, 결과값은 AnnouncementStore의 announcementList에 저장됩니다.
     */
    case announcementAll
    /**
     1대1 문의내역을 불러올 때 사용, limit으로 불러올 데이터의 수를 제한 할 수 있으며, OneToOneInquiryStore의 oneToOneInquiryList에 저장됩니다.
     
     제한된 수의 데이터를 불러오기 때문에 불러온 데이터를 모두 보여주었다면 다시 그 이후의 데이터를 더 불러와야 합니다.
     */
    case oneToOneInquiryAll(sellerID: String, limit: Int)
    /**
     친환경 가게 정보를 모두 불러올 때 사용, 결과값은 ZeroWasteShopStore의 zeroWasteShopList에 저장됩니다.
     */
    case zeroWasteShopLoadAll
}
