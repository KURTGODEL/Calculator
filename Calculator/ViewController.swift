//
//  ViewController.swift
//  Calculator
//
//  Created by Student on 2019-11-18.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var result1: PaddingLabel!
    
    @IBOutlet weak var acButton: CustomButton!
    @IBOutlet weak var delButton: CustomButton!
    @IBOutlet weak var resultButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        result1.layer.borderWidth = 2.0;
        result1.layer.borderColor = UIColor.lightGray.cgColor;
        result1.layer.cornerRadius = 5;
        result1.layer.masksToBounds = true;
        
        acButton.backgroundColor = UIColor.orange;
        delButton.backgroundColor = UIColor.red;
        resultButton.backgroundColor = UIColor.gray;
    }
    
    var resultValue:String {
        get{
            return result1.text!;
        }
        
        set{
            result1.text = String(newValue);
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let value: String = sender.titleLabel?.text{
            switch (value){
                case "π":
                    resultValue = String(Double.pi);
                case "√":
                    resultValue = String(sqrt(Double(resultValue)!));
                case "AC":
                    resultValue = "0";
                default:
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
            
            if(value == "0" && typed != "0"){
                value = typed;
            }else if(value == "0" && typed == "0"){
                value = "0";
            }else if(value != "0"){
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
    }
}
