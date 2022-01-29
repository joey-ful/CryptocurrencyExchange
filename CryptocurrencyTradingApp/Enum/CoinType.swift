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
        default:
            return "나머지"
        }
    }
}
