//
//  ViewController.swift
//  Calculator
//
//  Created by Erick Araujo on 2019-11-18.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var result1: PaddingLabel!
    
    @IBOutlet weak var acButton: CustomButton!;
    @IBOutlet weak var delButton: CustomButton!;
    @IBOutlet weak var resultButton: CustomButton!;
    @IBOutlet weak var barItemFinancial: UITabBarItem!;
    @IBOutlet weak var barItemScientific: UITabBarItem!;
    @IBOutlet weak var tabBar: UITabBar!;
    @IBOutlet weak var financialView: UIView!;
    @IBOutlet weak var scientificView: UIView!;
    
    var brain: CalculatorBrain = CalculatorBrain();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        result1.layer.borderWidth = 2.0;
        result1.layer.borderColor = UIColor.lightGray.cgColor;
        result1.layer.cornerRadius = 5;
        result1.layer.masksToBounds = true;
        
        if acButton != nil{
            acButton.backgroundColor = UIColor.orange;
            delButton.backgroundColor = UIColor.red;
            resultButton.backgroundColor = UIColor.gray;
        }
        
        tabBar.selectedItem = tabBar.items?.first;
        tabBar.delegate = self;
        
        scientificView.isHidden = true;
    }
    
    // Show View Controller with new calculator modes
    func showVC(number: Int){
        financialView.isHidden = true;
        scientificView.isHidden = true;
        
        switch number {
            case 0:
                financialView.isHidden = false;
                break;
            case 1:
                scientificView.isHidden = false;
                break;
            default:
                break;
        }
    }
    
    var resultValue:String {
        get{
            return result1.text!;
        }
        
        set{
            result1.text = String(newValue);
            
            if(result1.text == ""){
                result1.text = "0";
            }
            
            let size = result1.text!.count;
            
            if(size > 10 && size < 20){
                result1.font = UIFont(name: result1.font.fontName, size: 32);
            }else if(size >= 20){
                result1.font = UIFont(name: result1.font.fontName, size: 25);
            }
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let value: String = sender.titleLabel?.text{
            switch (value){
                case let op where
                        op == "/" ||
                        op == "*" ||
                        op == "+" ||
                        op == "-" ||
                        op == "%":
                    resultValue = resultValue + op;
                case "()":
                    for l in String(resultValue.reversed()) {
                        if(l == "("){
                            resultValue = resultValue + ")";
                            break;
                        }else if(l == ")"){
                            resultValue = resultValue + "(";
                            break;
                        }else{
                            if(brain.isEmpty(resultValue)){
                                resultValue = "(";
                            }else{
                                if(!resultValue.contains("(") && !resultValue.contains(")")){
                                    resultValue = resultValue + "(";
                                }
                            }
                        }
                    }
                case "🔙":
                    resultValue = String(resultValue.dropLast());
                case "=":
                    brain.setDisplay(resultValue);
                    brain.performOperation(value);
                    resultValue = brain.result!;
                default:
                    brain.setOperand(resultValue);
                    brain.performOperation(value);
                    resultValue = brain.result!;
                    break;
            }
        }
    }
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let typed:String = sender.titleLabel?.text {
            var value:String = resultValue;
            
            if(typed == "="){
                value = "0";
                return;
            }
            
            if(brain.isEmpty(value) && typed != "0"){
                value = typed;
            }else if(brain.isEmpty(value) && typed == "0"){
                value = "0";
            }else if(!brain.isEmpty(value)){
                value = String(value) + typed;
            }
            
            resultValue = String(value);
        }
    }
}


@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 16.0
    @IBInspectable var rightInset: CGFloat = 16.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

// Customize UIButton with new properties like borderColor
@IBDesignable class CustomButton: UIButton {
    
    var borderWidth: CGFloat = 2.0;
    var borderColor = UIColor.lightGray.cgColor;
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal);
            self.setTitleColor(UIColor.black,for: .normal);
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews();
        setup();
    }
    
    func setup() {
        self.clipsToBounds = true;
        self.layer.cornerRadius = 5.0; //self.frame.size.width / 2.0
        self.layer.borderColor = borderColor;
        self.layer.borderWidth = borderWidth;
        
        if(self.backgroundColor == nil){
            self.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0);
        }
    }
}

// Extension for UITabBar trigger Item Selection
extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        showVC(number: item.tag);
    }
    
}
