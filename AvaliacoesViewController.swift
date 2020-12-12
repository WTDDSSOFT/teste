//
//  AvaliacoesViewController.swift
//  Samel
//
//  Created by samel developer on 07/12/20.
//  Copyright © 2020 Samel. All rights reserved.
//

import UIKit
import Cosmos

class AvaliacoesViewController: UIViewController {
  
  var avaliacoesHistorico: [AvaliacoesHistorico]?
  let formatter = NumberFormatter()
    
  var idPergunta:String?
  var idAtendimento:Int?
  var idEvolucao:Int?
  var dsDescricao:String?
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBAction func sensResposta(_ sender: Any) {
    SMMinhaInternacaoData.enviarAvaliacoes.idAtendimento = self.idAtendimento
    SMMinhaInternacaoData.enviarAvaliacoes.idPergunta = self.idPergunta
    SMMinhaInternacaoData.enviarAvaliacoes.idEvolucao = self.idEvolucao
  SMMinhaInternacaoData.enviarAvaliacoes.dsDescricao = self.dsDescricao
    self.performSegue(withIdentifier: "segueEnviarAvaliacoes", sender: self)

}
  override func viewDidLoad() {
    super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
  }
  
}

extension AvaliacoesViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let lbHistoricoNil = UILabel(frame: CGRect(x: 15, y: 10, width: 300, height: 50))
    
    if(avaliacoesHistorico?.count == 0 ){
      lbHistoricoNil.textAlignment = .center
      lbHistoricoNil.text = "Você não possui avaliacões disponivies"
      lbHistoricoNil.adjustsFontSizeToFitWidth = true
      lbHistoricoNil.font = UIFont.appBoldFontWith(size: 20)
      lbHistoricoNil.textColor = Colors.neutralMedium
      view.addSubview(lbHistoricoNil)
      
      lbHistoricoNil.translatesAutoresizingMaskIntoConstraints = true
      lbHistoricoNil.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
      lbHistoricoNil.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
    }else{
      lbHistoricoNil.isHidden = true
    }
    return avaliacoesHistorico?.count ?? 0
  }
  
}

extension AvaliacoesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AvaliacoesCell", for: indexPath) as! AvaliaTableViewCell
    
    if let avaliacoes = avaliacoesHistorico {
      
    
//      let sendToString = formatter.string(from: NSNumber(nonretainedObject: MinhaInternacaoAvaliacoes.confirmarDados.ratingStats))
//

      let pergunta = avaliacoes[indexPath.row].dsPergunta!
      let limpeza = avaliacoes[indexPath.row].dsPergunta!
      let alimentacao = avaliacoes[indexPath.row].dsPergunta!

      let getMd = "Médico"
      let mgMdica = "Enfermagem"
      let getHigienizacao = "Higienização"
      let getAlimentacao = "Alimentação"
      
      if ((pergunta.range(of: getMd)) != nil || ((pergunta.range(of: mgMdica)) != nil) ){
        cell.uImageView?.image = UIImage(named: "medico")
        cell.uImageView?.frame.integral
      }else if ((limpeza.range(of: getHigienizacao)) != nil){
        cell.uImageView?.image = UIImage(named: "limpeza")
        cell.uImageView?.frame.integral

      }else if  ((alimentacao.range(of: getAlimentacao)) != nil){
        cell.uImageView?.image = UIImage(named: "alimentacao")
        cell.uImageView?.frame.integral

      }else{
        cell.uImageView?.image = UIImage(named: "recep")
        cell.uImageView?.frame.integral

      }
      
      cell.lbNomeProfissional.text = avaliacoes[indexPath.row].medico
      cell.lbmedico.text = avaliacoes[indexPath.row].dsEvolucao
  
      
      cell.cosmoView?.settings.fillMode = .full
      cell.cosmoView?.settings.totalStars = 5
      cell.cosmoView?.didFinishTouchingCosmos = {
        rating in
        
        if (rating > 0.0 && rating < 1.0) {
          self.dsDescricao = String(1)
          print("deDescricao",  self.dsDescricao! )
        }else if (rating > 1.0 && rating <= 2.0){
          self.dsDescricao = String(2)
          print("deDescricao",  self.dsDescricao! )
  
        }else if( rating > 3.0 && rating <=  4.0){
          self.dsDescricao = String(3)
          print("deDescricao",  self.dsDescricao! )
  
        }else if( rating > 4.0 && rating <= 5.0){
          self.dsDescricao = String(4)
          print("deDescricao",  self.dsDescricao! )
  
        }else if( rating <= 5.0){
          self.dsDescricao = String(5)
          print("deDescricao",  self.dsDescricao! )
  
        }
        print("dataStars", rating)
      }
      cell.cosmoView?.rating.round()
      cell.cosmoView?.update()
      MinhaInternacaoAvaliacoes.confirmarDados.avaliacao =  cell.cosmoView?.rating.rounded(toPlaces: 0)

      var dataStars = MinhaInternacaoAvaliacoes.confirmarDados.avaliacao

      self.idAtendimento = avaliacoes[indexPath.row].idAtendimento
      self.idEvolucao = avaliacoes[indexPath.row].idEvolucao
      self.idPergunta = avaliacoes[indexPath.row].idPergunta
      let sendToString = formatter.string(from: NSNumber(nonretainedObject: dataStars))
      
      print("idAtendimento",self.idAtendimento!)
      print("idEvolucao",self.idEvolucao!)
      print("idPergunta",self.idPergunta!)
      
    }
    return cell
  }
}
