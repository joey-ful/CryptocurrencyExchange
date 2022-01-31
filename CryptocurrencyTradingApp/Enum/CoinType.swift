//
//  Coin.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

enum CoinType: String, CaseIterable {
    case btc, eth, ltc, etc
    case xrp, bch, qtum, btg
    case eos, icx, trx, elf
    case omg, knc, glm, zil
    case waxp, powr, lrc, steem
    case strax, zrx, rep, xem
    case snt, ada, ctxc, bat
    case wtc, theta, loom, waves
    case dataTRUE, link, enj, vet
    case mtl, iost, tmtg, qkc
    case atolo, amo, bsv, orbs
    case tfuel, valor, con, ankr
    case mix, cro, fx, chr
    case mbl, mxc, fct, trv
    case dad, wom, soc, boa
    case fcasea, sxp, cos, apix
    case el, basic, hive, xpr
    case vra, fit, egg, bora
    case arpa, ctc, apm, ckb
    case aergo, anw, cennz, evz
    case cyclub, srm, qtcon, uni
    case yfi, uma, aave, comp
    case ren, bal, rsr, nmr
    case rlc, uos, sand, gom2
    case ringx, bel, obsr, orc
    case pola, awo, adp, dvi
    case ghx, mir, mvc, bly
    case wozx, anv, grt, mm
    case biot, xno, snx, sofi
    case cola, nu, oxt, lina
    case map, aqt, wiken, ctsi
    case mana, lpt, mkr, sushi
    case asm, pundix, celr, lf
    case arw, msb, rly, ocean
    case bfc, alice, coti, cake
    case bnt, xvs, chz, axs
    case dai, matic, bake, velo
    case bcd, xlm, gxc, vsys
    case ipx, wicc, ont, luna
    case aion, meta, klay, ong
    case algo, jst, xtz, mlk
    case wemix, dot, atom, ssx
    case temco, hibs, burger, doge
    case ksm, ctk, xym, bnb
    case nft, sun, xec, pci
    case sol, boba, gala, btt
    case dao, rnt, ppt, stpt
    case hyc, chl, bznt, lzm
    case ethos, keos, xsr, news
    case front, npxs, add, bxa
    case horus, ven, wpx, hc
    case smr, cbk, bttold, rom
    case oneInch = "1inch"
    case poly, meetone, apis, bhp
    case woo, dvc, mco, cmt
    case cvt, qbz, salt, ae
    case pay, srt, fab, drm
    case qi, zec, gto, sun_old
    case asta, fleta, dash, don
    case wet, c98, plx, auto
    case dac, em, rpg, xvg
    case itc, pcm, etz, bcha
    case abt, ln, bnp, lamb
    case ogo, dvp, ocn, lba
    case eosdac, win, pch, `true`
    case sgb, dacc, onx, med
    case cpay, ibp, arm, fnb
    case fzz, pst, cosm, bcdc
    case rdn, aoa, atd, mith, inx
    case black, pivx, anc, beth
    case xmr, nsbt, arn, ins
    
    var symbol: String {
        return self.rawValue.uppercased()
    }
    
    var symbolKRW: String {
        return self.rawValue.uppercased() + "_KRW"
    }
    
    static var allCoins: [CoinType] {
        return CoinType.allCases
    }
    
    static func coin(symbol: String) -> CoinType? {
        let matchList = CoinType.allCases.filter { $0.rawValue == symbol.lowercased() }
        return matchList == [] ? nil : matchList[0]
    }
    
    var name: String {
            switch self {
            case .btc:
                return "비트코인"
            case .eth:
                return "이더리움"
            case .etc:
                return "이더리움 클래식"
            case .ltc:
                return "라이트코인"
            case .xrp:
                return "리플"
            case .bch:
                return "비트코인 캐시"
            case .qtum:
                return "퀀텀"
            case .btg:
                return "비트코인 골드"
            case .eos:
                return "이오스"
            case .icx:
                return "아이콘"
            case .trx:
                return "트론"
            case .elf:
                return "엘프"
            case .omg:
                return "오미세고"
            case .knc:
                return "카이버 네트워크"
            case .glm:
                return "골렘"
            case .zil:
                return "질리카"
            case .waxp:
                return "왁스"
            case .powr:
                return "파워렛저"
            case .lrc:
                return "루프링"
            case .steem:
                return "스팀"
            case .strax:
                return "스트라티스"
            case .zrx:
                return "제로엑스"
            case .rep:
                return "어거"
            case .xem:
                return "넴"
            case .snt:
                return "스테이터스네트워크토큰"
            case .ada:
                return "에이다"
            case .ctxc:
                return "코르텍스"
            case .bat:
                return "베이직어텐션토큰"
            case .wtc:
                return "월튼체인"
            case .theta:
                return "쎄타토큰"
            case .loom:
                return "룸네트워크"
            case .waves:
                return "웨이브"
            case .link:
                return "체인링크"
            case .enj:
                return "엔진코인"
            case .vet:
                return "비체인"
            case .mtl:
                return "메탈"
            case .iost:
                return "이오스트"
            case .tmtg:
                return "더마이다스터치골드"
            case .qkc:
                return "쿼크체인"
            case .atolo:
                return "라이즌"
            case .amo:
                return "아모코인"
            case .bsv:
                return "비트코인에스브이"
            case .orbs:
                return "오브스"
            case .tfuel:
                return "쎄타퓨엘"
            case .valor:
                return "밸러토큰"
            case .con:
                return "코넌"
            case .ankr:
                return "앵커"
            case .mix:
                return "믹스마블"
            case .cro:
                return "크립토닷컴체인"
            case .fx:
                return "펑션엑스"
            case .chr:
                return "크로미아"
            case .mbl:
                return "무비블록"
            case .mxc:
                return "머신익스체인지코인"
            case .fct:
                return "피르마체인"
            case .trv:
                return "트러스트버스"
            case .dad:
                return "다드"
            case .wom:
                return "왐토큰"
            case .soc:
                return "소다코인"
            case .boa:
                return "보아"
            case .sxp:
                return "스와이프"
            case .cos:
                return "콘텐토스"
            case .apix:
                return "아픽스"
            case .el:
                return "엘리시아"
            case .basic:
                return "베이직"
            case .hive:
                return "하이브"
            case .xpr:
                return "프로톤"
            case .vra:
                return "베라시티"
            case .fit:
                return "300피트 네트워크"
            case .egg:
                return "네스트리"
            case .bora:
                return "보라"
            case .arpa:
                return "알파체인"
            case .ctc:
                return "크레딧코인"
            case .apm:
                return "에이피엠 코인"
            case .ckb:
                return "너보스"
            case .aergo:
                return "아르고"
            case .anw:
                return "앵커뉴럴월드"
            case .cennz:
                return "센트럴리티"
            case .evz:
                return "이브이지"
            case .cyclub:
                return "싸이클럽"
            case .srm:
                return "세럼"
            case .qtcon:
                return "퀴즈톡"
            case .uni:
                return "유니스왑"
            case .yfi:
                return "연파이낸스"
            case .uma:
                return "우마"
            case .aave:
                return "에이브"
            case .comp:
                return "컴파운드"
            case .ren:
                return "렌"
            case .bal:
                return "밸런서"
            case .rsr:
                return "리저브라이트"
            case .nmr:
                return "뉴메레르"
            case .rlc:
                return "아이젝"
            case .uos:
                return "울트라"
            case .sand:
                return "샌드박스"
            case .gom2:
                return "고머니2"
            case .ringx:
                return "링엑스"
            case .bel:
                return "벨라프로토콜"
            case .obsr:
                return "옵저버"
            case .orc:
                return "오르빗 체인"
            case .pola:
                return "폴라리스 쉐어"
            case .awo:
                return "에이아이워크"
            case .adp:
                return "어댑터 토큰"
            case .dvi:
                return "디비전"
            case .ghx:
                return "게이머코인"
            case .mir:
                return "미러 프로토콜"
            case .mvc:
                return "마일벌스"
            case .bly:
                return "블로서리"
            case .wozx:
                return "이포스"
            case .anv:
                return "애니버스"
            case .grt:
                return "더그래프"
            case .mm:
                return "밀리미터토큰"
            case .biot:
                return "바이오패스포트"
            case .xno:
                return "제노토큰"
            case .snx:
                return "신세틱스"
            case .sofi:
                return "라이파이낸스"
            case .cola:
                return "콜라토큰"
            case .nu:
                return "누사이퍼"
            case .oxt:
                return "오키드"
            case .lina:
                return "리니어파이낸스"
            case .map:
                return "맵프로토콜"
            case .aqt:
                return "알파쿼크"
            case .wiken:
                return "위드"
            case .ctsi:
                return "카르테시"
            case .mana:
                return "디센트럴랜드"
            case .lpt:
                return "라이브피어"
            case .mkr:
                return "메이커"
            case .sushi:
                return "스시스왑"
            case .asm:
                return "어셈블프로토콜"
            case .pundix:
                return "펀디엑스"
            case .celr:
                return "셀러네트워크"
            case .lf:
                return "링크플로우"
            case .arw:
                return "아로와나토큰"
            case .msb:
                return "미스블록"
            case .rly:
                return "랠리"
            case .ocean:
                return "오션프로토콜"
            case .bfc:
                return "바이프로스트"
            case .alice:
                return "마이네이버앨리스"
            case .coti:
                return "코티"
            case .cake:
                return "팬케이크스왑"
            case .bnt:
                return "뱅코르"
            case .xvs:
                return "비너스"
            case .chz:
                return "칠리즈"
            case .axs:
                return "엑시인피니티"
            case .dai:
                return "다이"
            case .matic:
                return "폴리곤"
            case .bake:
                return "베이커리토큰"
            case .velo:
                return "벨로프로토콜"
            case .bcd:
                return "비트코인 다이아몬드"
            case .xlm:
                return "스텔라루멘"
            case .gxc:
                return "지엑스체인"
            case .vsys:
                return "브이시스템즈"
            case .ipx:
                return "타키온프로토콜"
            case .wicc:
                return "웨이키체인"
            case .ont:
                return "온톨로지"
            case .luna:
                return "루나"
            case .arn:
                return "연파이낸스"
            case .aion:
                return "아이온"
            case .meta:
                return "메타디움"
            case .klay:
                return "클레이튼"
            case .ong:
                return "온톨로지가스"
            case .algo:
                return "알고랜드"
            case .jst:
                return "저스트"
            case .xtz:
                return "테조스"
            case .mlk:
                return "밀크"
            case .wemix:
                return "위믹스"
            case .dot:
                return "폴카닷"
            case .atom:
                return "코스모스"
            case .ssx:
                return "썸씽"
            case .temco:
                return "템코"
            case .hibs:
                return "힙스"
            case .burger:
                return "버거스왑"
            case .doge:
                return "도지코인"
            case .ksm:
                return "쿠시마"
            case .ctk:
                return "써틱"
            case .xym:
                return "심볼"
            case .bnb:
                return "바이낸스코인"
            case .nft:
                return "에이피이엔에프티"
            case .sun:
                return "썬"
            case .xec:
                return "이캐시"
            case .pci:
                return "페이코인"
            case .sol:
                return "솔라나"
            case .boba:
                return "보바토큰"
            case .gala:
                return "갈라"
            case .btt:
                return "비트토렌트"
            case .dao:
                return "다오메이커"
            case .ppt:
                return "어댑터토큰"
            case .front:
                return "프론티어"
            case .ven:
                return "비너스"
            case .poly:
                return "폴리곤"
            case .woo:
                return "우네트워크"
            case .fleta:
                return "플레타"
            case .c98:
                return "코인98"
            case .true:
                return "트루체인"
            case .med:
                return "메디블록"
            default:
                return "-"
            }
        }
}
