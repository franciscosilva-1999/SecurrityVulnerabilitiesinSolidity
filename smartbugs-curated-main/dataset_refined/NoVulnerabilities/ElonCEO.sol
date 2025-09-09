/**
 *Submitted for verification at BscScan.com on 2024-04-24
*/

/**
 *
 *  ✅Elon CEO is a memetion that potential to hit 100m mcap! - $ELONCEO
 *  ✅TG: @ElonCEO_Official
 *  ✅X: @ElonCEO_Meme  
 *  ✅Web: ElonCEO.live   
 *     
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {return msg.sender;}
    function _msgData() internal view virtual returns (bytes memory) {this; return msg.data;}
}

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) { return _owner; }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "STOP! You are not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        _owner = address(0);
        emit OwnershipTransferred(_owner, address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "STOP! No zero address - call renounceOwnership instead");
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {_name = name_; _symbol = symbol_;}
    function name() public view virtual override returns (string memory) {return _name;}
    function symbol() public view virtual override returns (string memory) {return _symbol;}
    function decimals() public view virtual override returns (uint8) {return 18;}
    function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
    function transfer(address to, uint256 amount) public virtual override returns (bool) {_transfer(_msgSender(), to, amount); return true;}
    function allowance(address owner, address spender) public view virtual override returns (uint256) {return _allowances[owner][spender];}
    function approve(address spender, uint256 amount) public virtual override returns (bool) {_approve(_msgSender(), spender, amount); return true;}
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {_spendAllowance(from, _msgSender(), amount); _transfer(from, to, amount); return true;}
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {_approve(_msgSender(), spender, allowance(_msgSender(), spender) + addedValue); return true;}
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = allowance(_msgSender(), spender);
        require(currentAllowance >= subtractedValue, "STOP: decreased allowance below zero");
        unchecked {_approve(_msgSender(), spender, currentAllowance - subtractedValue);}
        return true;
    }
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0) && to != address(0), "STOP: transfer from/to the zero address");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "STOP: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "STOP: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked {_balances[account] += amount;}
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "STOP: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "STOP: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0) && spender != address(0), "STOP: approve from/to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "STOP: insufficient allowance");
            unchecked {_approve(owner, spender, currentAllowance - amount);}
        }
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

interface IDexFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDexRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
}

contract ELONCEO is ERC20, Ownable {
    uint256 private constant _totalSupply = 1_000_000_000_000_000 * 1e18;
    IDexRouter public uniswapRouter;
    address public pairAddress;
    address public marketingWallet = 0xFc5540e6A2Df9886bF934E1D89792795b42b6B62;
    uint256 public swapTokensAtAmount = _totalSupply / 100000; // 0.001% of _totalSupply
    uint256 public startTradingBlock;
    bool public tradingEnabled = false;
    bool public swapAndLiquifyEnabled = true;
    bool public isSwapping = false;

    mapping(address => bool) private whitelisted;
    
    struct Tax {
        uint256 marketingTax;
    }
    
    Tax public buyTax = Tax(5);
    Tax public sellTax = Tax(5);

    event TradingEnabled(uint256 startBlock);
    event SwappingToggled(bool newState);
    event WhitelistUpdated(address indexed wallet, bool status);
    event BNBCleared(address indexed wallet, uint256 amount);
    event TokensCleared(address indexed tokenAddress, address indexed wallet, uint256 amount);
    event TaxCollected(address indexed from, address indexed to, uint256 amount, uint256 taxAmount);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived);
    event TransferTaxed(address indexed from, address indexed to, uint256 amount, uint256 taxedAmount);
    event TokensSwappedForBNB(uint256 tokenAmount, uint256 minEthReceived);

    constructor() ERC20("Elon CEO", "ELONCEO") {
        uniswapRouter = IDexRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // BSC Pancake Mainnet Router
        pairAddress = IDexFactory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
        _mint(msg.sender, _totalSupply); // One-time mint only
        whitelisted[msg.sender] = true;
        whitelisted[address(uniswapRouter)] = true;
        whitelisted[address(this)] = true;
    }

    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "STOP! Trading is live");
        tradingEnabled = true;
        startTradingBlock = block.number;
        emit TradingEnabled(startTradingBlock);
    }

    function setWhitelistStatus(address _wallet, bool _status) external onlyOwner {
        whitelisted[_wallet] = _status;
        emit WhitelistUpdated(_wallet, _status);
    }

    function toggleSwapping() external {
        require(msg.sender == marketingWallet, "STOP! Caller is not marketing wallet");
        swapAndLiquifyEnabled = !swapAndLiquifyEnabled;
        emit SwappingToggled(swapAndLiquifyEnabled);
    }

    function clearBNB() external {
        require(msg.sender == marketingWallet, "STOP! Caller is not marketing wallet");
        uint256 amount = address(this).balance;
        require(amount > 0, "STOP! No BNB in contract");
        payable(msg.sender).transfer(amount);
        emit BNBCleared(msg.sender, amount);
    }

    // WARNING: Use this function with trusted tokens only
    function clearTokens(address _tokenAddress) external {
        require(msg.sender == marketingWallet, "STOP! Caller is not marketing wallet");
        IERC20 token = IERC20(_tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "STOP! No token in contract");
        token.transfer(msg.sender, balance);
        emit TokensCleared(_tokenAddress, msg.sender, balance);
    }

    function checkWhitelist(address _wallet) external view returns (bool) {
        return whitelisted[_wallet];
    }

    function _takeTax(address _from, address _to, uint256 _amount) internal returns (uint256) {
        if (whitelisted[_from] || whitelisted[_to]) {
            return _amount;
        }
        uint256 totalTax = 0;
        if (_to == pairAddress) {
            totalTax = sellTax.marketingTax;
        } else if (_from == pairAddress) {
            totalTax = buyTax.marketingTax;
        }
        uint256 tax = 0;
        if (totalTax > 0) {
            tax = (_amount * totalTax) / 100;
            super._transfer(_from, address(this), tax);
            emit TaxCollected(_from, _to, _amount, tax);
        }
        return (_amount - tax);
    }

    function _transfer(address _from, address _to, uint256 _amount) internal virtual override {
        require(_from != address(0), "STOP! Transfer from address zero");
        require(_to != address(0), "STOP! Transfer to address zero");
        require(_amount > 0, "STOP! Transfer amount must be greater than zero");
        uint256 toTransfer = _takeTax(_from, _to, _amount);
        bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
        if (!whitelisted[_from] && !whitelisted[_to]) {
            require(tradingEnabled, "STOP! Trading is not live");
            if (pairAddress == _to && swapAndLiquifyEnabled && canSwap && !isSwapping) {
                internalSwap();
            }
        }
        super._transfer(_from, _to, toTransfer);
        emit TransferTaxed(_from, _to, _amount, toTransfer);
    }

    function internalSwap() internal {
        isSwapping = true;
        uint256 taxAmount = balanceOf(address(this));
        if (taxAmount == 0) {
            isSwapping = false;
            return;
        }
        uint256 initialBalance = address(this).balance;
        swapToBNB(taxAmount);
        uint256 newBalance = address(this).balance - initialBalance;
        (bool success, ) = marketingWallet.call{value: newBalance}("");
        require(success, "STOP! Failed transfer to tax wallet");
        emit SwapAndLiquify(taxAmount, newBalance);
        isSwapping = false;
    }

    function swapToBNB(uint256 _amount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapRouter.WETH();
        _approve(address(this), address(uniswapRouter), _amount);
        uint256 initialBalance = address(this).balance;
        uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amount,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 newBalance = address(this).balance - initialBalance;
        emit TokensSwappedForBNB(_amount, newBalance);
    }

    receive() external payable {}
}