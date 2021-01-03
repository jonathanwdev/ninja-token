// SPDX-License-Identifier: MIT
pragma solidity 0.7.4;
import "ownable.sol";
import "safemath.sol";


abstract contract ERC20  {
    function totalSupply() public virtual view returns (uint);
    function balanceOf(address tokenOwner) public virtual view returns (uint balance);
    function allowance(address tokenOwner, address spender) public virtual view returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spender, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
  using SafeMath for uint;

  uint internal _totalSupply;
  mapping(address => uint) internal _balances;
  mapping(address => mapping (address => uint)) internal _allowed;


  function totalSupply() public override view returns (uint) {
    return _totalSupply;
  }

  function balanceOf(address tokenOwner) public override view returns (uint balance) {
    return _balances[tokenOwner];
  }

  function transfer(address to, uint tokens) public override returns (bool success) {
    require(_balances[msg.sender] >= tokens);
    require(to != address(0));
    _balances[msg.sender] = _balances[msg.sender].sub(tokens);
    _balances[to] = _balances[to].add(tokens);

    emit Transfer(msg.sender, to,tokens);

    return true;
  }

  function approve(address spender, uint tokens) public override returns (bool success) {
    require (tokens == 0 && _allowed[msg.sender][spender] == 0);
    _allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);

    return true;
  }

  function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
    return _allowed[tokenOwner][spender];

  }

  function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
    require(_allowed[from][msg.sender] >= tokens);
    require(_balances[from] >= tokens);
    require(to != address(0));

    uint _allowance = _allowed[from][msg.sender];

    _balances[from] = _balances[from].sub(tokens);
    _balances[to] = _balances[to].add(tokens);
    _allowed[from][msg.sender] = _allowance.sub(tokens);

    emit Transfer(from, to, tokens);

    return true;
  }

}

contract MintableToken is BasicToken {
  using SafeMath for uint;

  event Mint(address indexed to, uint tokens);

  function mint(address to, uint tokens) onlyOwner public {

    _balances[to] = _balances[to].add(tokens);
    _totalSupply = _totalSupply.add(tokens);

    emit Mint(to, tokens);
  }
}

contract NinjaCoin is MintableToken {
  string public constant name = "Ninja Coin";
  string public constant symbol = "NIJ";
  uint8 public constant decimals = 18;
}





