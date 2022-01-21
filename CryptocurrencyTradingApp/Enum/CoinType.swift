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
    
    var sysmbol: String {
        return "\(self.rawValue.uppercased())_KRW"
    }
    
    static var allCoins: [CoinType] {
        return CoinType.allCases
    }
    
    static func name(symbol: String) -> String? {
        switch symbol {
        case "btc":
            return "비트코인"
        case "eth":
            return "이더리움"
        case "etc":
            return "이더리움 클래식"
        default:
            return "나머지"
        }
    }
}
