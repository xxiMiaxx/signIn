

import UIKit

enum DropDownDirection {
    case top, bottom
}

class DropDownMenu: UIButton {
    
    @IBInspectable var text: String {
        get {
            return title(for: .normal) ?? ""
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    @IBInspectable var visibleItemCount: Int = 5
    var direction: DropDownDirection = .bottom
    
    var contentTextColor: UIColor = .black {
        didSet {
            tableView?.reloadData()
        }
    }
    var contentBackgroundColor: UIColor = .white {
        didSet {
            tableView?.backgroundColor = contentBackgroundColor
        }
    }
    
    var selectedContentTextColor: UIColor = .orange {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var selectedContentBackgroundColor: UIColor = .white {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var contentTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            tableView?.reloadData()
        }
    }
    var items = [String]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var superSuperView: UIView!
    let duration: TimeInterval = 0.25
    
    var selectedIndex = -1 {
        didSet {
            didSelectedItemIndex?(selectedIndex)
        }
    }
    var isOpenDropdown = true {
        didSet {
            if isOpenDropdown {
                hideDropDown()
            } else {
                showDropDown()
            }
        }
    }
    
    fileprivate var tableViewHeightConstraint: NSLayoutConstraint!
    fileprivate var tableView: UITableView!
    
    var didSelectedItemIndex: ((Int) -> (Void))?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: #selector(didSelectedButton(_:)), for: .touchUpInside)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = bounds.size.height
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 6
        backgroundColor = UIColor.white
        clipsToBounds = false
        contentHorizontalAlignment = .left
        setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc private func didSelectedButton(_ sender: UIButton) {
        isOpenDropdown = !isOpenDropdown
    }
}

extension DropDownMenu {
    
    private var itemHeight: CGFloat {
        if items.count > visibleItemCount {
            return CGFloat(visibleItemCount) * bounds.size.height
        } else {
            return CGFloat(items.count) * bounds.size.height
        }
    }
    fileprivate func hideDropDown() {
        tableViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.tableView.center.y -= self.itemHeight / 2
            self.tableView.layoutIfNeeded()
        }) { [unowned self] finished in
            self.tableView.isHidden = true
        }
    }
    fileprivate func showDropDown() {
        
        if self.tableViewHeightConstraint == nil {
            self.superSuperView.addSubview(tableView)
            self.superSuperView.bringSubview(toFront: tableView)
            
            tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            tableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0 )
            tableViewHeightConstraint.isActive = true
            
            switch direction {
            case .bottom:
                tableView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
            case .top:
                tableView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -2).isActive = true
            }
        }
        
        tableView.layer.cornerRadius = self.layer.cornerRadius
        self.tableView.isHidden = false
        tableViewHeightConstraint.constant = itemHeight
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.tableView.center.y += self.itemHeight / 2
            self.tableView.layoutIfNeeded()
        }, completion: nil)
    }
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropDownCellIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "dropDownCellIdentifier")
        
        cell.backgroundColor = .clear
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = contentTextFont
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = selectedContentBackgroundColor
            cell.textLabel?.textColor = selectedContentTextColor
        } else  {
            cell.backgroundColor = contentBackgroundColor
            cell.textLabel?.textColor = contentTextColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        isOpenDropdown = true
        selectedIndex = indexPath.row
    }
}
