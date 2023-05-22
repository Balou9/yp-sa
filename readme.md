# Vulnerability Summary - Yieldprotocol

This is a summary with vulnerabilites of medium impact. A complete report can be found [here](./yieldprotocol-slither-report.md). Vulnerabilities of high impact could not be found.

 - [unused-return-yield-utils-v2](#unused-return-yield-utils-v2) (1 results) (Impact: Medium)
 - [reentrancy-no-eth-I-yield-utils-v2](#reentrancy-no-eth-I-yield-utils-v2) (7 results) (Impact: Medium)
 - [mapping-deletion-yield-utils-v2](#mapping-deletion-yield-utils-v2) (1 results) (Impact: Medium)
 - [uninitialized-local-yield-utils-v2](#uninitialized-local-yield-utils-v2) (2 results) (Impact: Medium)
 - [divide-before-multiply-yield-utils-v2](#divide-before-multiply-yield-utils-v2) (1 results) (Impact: Medium)
 - [reentrancy-no-eth-II-yield-utils-v2](#reentrancy-no-eth-II-yield-utils-v2) (7 results) (Impact: Medium)
 - [write-after-write-vault-v2](#write-after-write-vault-v2) (1 results) (Impact: Medium)
 - [divide-before-multiply-vault-v2](#divide-before-multiply-vault-v2) (8 results) (Impact: Medium)
 - [erc20-interface-vault-v2](#erc20-interface-vault-v2) (3 results) (Impact: Medium)

### unused-return-yield-utils-v2
#### Recommendation
Ensure that all the return values of the function calls are used.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/lib/forge-std/lib/ds-test/demo/demo.sol
- [ ] ID-0
[DemoTest.test_trace()](yield-utils-v2/lib/forge-std/lib/ds-test/demo/demo.sol#L43-L45) ignores return value by [this.echo(string 1,string 2)](yield-utils-v2/lib/forge-std/lib/ds-test/demo/demo.sol#L44)

yield-utils-v2/lib/forge-std/lib/ds-test/demo/demo.sol#L43-L45

### reentrancy-no-eth-I-yield-utils-v2
#### Recommendation
Apply the [check-effects-interactions](https://docs.soliditylang.org/en/v0.4.21/security-considerations.html#re-entrancy) pattern.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/src/token/ERC20Rewards.sol
- [ ] ID-0
Reentrancy in [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124):
	External calls:
	- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	State variables written after the call(s):
	- [rewardsPerToken = rewardsPerToken_](yield-utils-v2/src/token/ERC20Rewards.sol#L121)
	[ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)

yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124

- [ ] ID-1
Reentrancy in [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139):
 External calls:
 - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 State variables written after the call(s):
 - [rewards[user] = userRewards_](yield-utils-v2/src/token/ERC20Rewards.sol#L135)
 [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
 - [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139


- [ ] ID-2
Reentrancy in [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100):
 External calls:
 - [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L87)
   - [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
 State variables written after the call(s):
 - [rewardsPerToken.lastUpdated = start](yield-utils-v2/src/token/ERC20Rewards.sol#L96)
 [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
 - [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
 - [rewardsPerToken.rate = rate](yield-utils-v2/src/token/ERC20Rewards.sol#L97)
 [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
 - [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
 - [rewardsPeriod.start = start](yield-utils-v2/src/token/ERC20Rewards.sol#L89)
 [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42)
 - [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
 - [rewardsPeriod.end = end](yield-utils-v2/src/token/ERC20Rewards.sol#L90)
 [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42)
 - [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)

yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100


- [ ] ID-3
Reentrancy in [ERC20Rewards._mint(address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L142-L149):
 External calls:
 - [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L146)
   - [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
 - [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L147)
   - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 State variables written after the call(s):
 - [super._mint(dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L148)
   - [_balanceOf[dst] = _balanceOf[dst] + wad](yield-utils-v2/src/token/ERC20.sol#L168)
 [ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
 - [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
 - [super._mint(dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L148)
   - [_totalSupply = _totalSupply + wad](yield-utils-v2/src/token/ERC20.sol#L169)
 [ERC20._totalSupply](yield-utils-v2/src/token/ERC20.sol#L29) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20.totalSupply()](yield-utils-v2/src/token/ERC20.sol#L48-L50)

yield-utils-v2/src/token/ERC20Rewards.sol#L142-L149


- [ ] ID-4
Reentrancy in [ERC20Rewards._burn(address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L152-L159):
 External calls:
 - [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L156)
   - [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
 - [_updateUserRewards(src)](yield-utils-v2/src/token/ERC20Rewards.sol#L157)
   - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 State variables written after the call(s):
 - [super._burn(src,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L158)
   - [_balanceOf[src] = _balanceOf[src] - wad](yield-utils-v2/src/token/ERC20.sol#L190)
 [ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
 - [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
 - [super._burn(src,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L158)
   - [_totalSupply = _totalSupply - wad](yield-utils-v2/src/token/ERC20.sol#L191)
 [ERC20._totalSupply](yield-utils-v2/src/token/ERC20.sol#L29) can be used in cross function reentrancies:
 - [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
 - [ERC20.totalSupply()](yield-utils-v2/src/token/ERC20.sol#L48-L50)

yield-utils-v2/src/token/ERC20Rewards.sol#L152-L159


- [ ] ID-5
Reentrancy in [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195):
 External calls:
 - [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L190)
   - [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
 - [claiming = _updateUserRewards(from)](yield-utils-v2/src/token/ERC20Rewards.sol#L191)
   - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 State variables written after the call(s):
 - [rewards[from].accumulated = 0](yield-utils-v2/src/token/ERC20Rewards.sol#L192)
 [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
 - [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195


- [ ] ID-6
Reentrancy in [ERC20Rewards._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L162-L167):
 External calls:
 - [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L163)
   - [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
 - [_updateUserRewards(src)](yield-utils-v2/src/token/ERC20Rewards.sol#L164)
   - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 - [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L165)
   - [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
 State variables written after the call(s):
 - [super._transfer(src,dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L166)
   - [_balanceOf[src] = _balanceOf[src] - wad](yield-utils-v2/src/token/ERC20.sol#L117)
   - [_balanceOf[dst] = _balanceOf[dst] + wad](yield-utils-v2/src/token/ERC20.sol#L118)
 [ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
 - [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
 - [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L165)
   - [rewards[user] = userRewards_](yield-utils-v2/src/token/ERC20Rewards.sol#L135)
 [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
 - [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
 - [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
 - [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L162-L167

### mapping-deletion-yield-utils-v2
#### Recommendation
Use a lock mechanism instead of a deletion to disable structure containing a mapping.

#### Description
Impact: Medium
Confidence: High
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/src/utils/EmergencyBrake.sol
- [ ] ID-0
[EmergencyBrake._erase(address)](yield-utils-v2/src/utils/EmergencyBrake.sol#L175-L192) deletes [IEmergencyBrake.Plan](yield-utils-v2/src/interfaces/IEmergencyBrake.sol#L7-L11) which contains a mapping:
	-[delete plans[user]](yield-utils-v2/src/utils/EmergencyBrake.sol#L191)

yield-utils-v2/src/utils/EmergencyBrake.sol#L175-L192

### uninitialized-local-yield-utils-v2
#### Recommendation
Initialize all the variables. If a variable is meant to be initialized to zero, explicitly set it to zero to improve code readability.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/src/utils/EmergencyBrake.sol
- [ ] ID-1
[EmergencyBrake.add(address,IEmergencyBrake.Permission[]).i](yield-utils-v2/src/utils/EmergencyBrake.sol#L94) is a local variable never initialized

yield-utils-v2/src/utils/EmergencyBrake.sol#L94


- [ ] ID-2
[EmergencyBrake.remove(address,IEmergencyBrake.Permission[]).i](yield-utils-v2/src/utils/EmergencyBrake.sol#L129) is a local variable never initialized

yield-utils-v2/src/utils/EmergencyBrake.sol#L129

### divide-before-multiply-yield-utils-v2
#### Recommendation
Consider ordering multiplication before division.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/src/utils/Math.sol
- [ ] ID-0
[Math.wpow(uint256,uint256)](yield-utils-v2/src/utils/Math.sol#L41-L116) performs a multiplication on the result of a division:
	- [x = xxRound_wpow_asm_0 / baseUnit](yield-utils-v2/src/utils/Math.sol#L91)
	- [zx_wpow_asm_0 = z * x](yield-utils-v2/src/utils/Math.sol#L96)

yield-utils-v2/src/utils/Math.sol#L41-L116


### reentrancy-no-eth-II-yield-utils-v2
#### Recommendation
Apply the [check-effects-interactions](https://docs.soliditylang.org/en/v0.4.21/security-considerations.html#re-entrancy) pattern.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/yield-utils-v2/tree/main/src/token/ERC20Rewards.sol
 - [ ] ID-0
Reentrancy in [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124):
	External calls:
	- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	State variables written after the call(s):
	- [rewardsPerToken = rewardsPerToken_](yield-utils-v2/src/token/ERC20Rewards.sol#L121)
	[ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)

yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124


 - [ ] ID-1
Reentrancy in [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139):
	External calls:
	- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	State variables written after the call(s):
	- [rewards[user] = userRewards_](yield-utils-v2/src/token/ERC20Rewards.sol#L135)
	[ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
	- [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139


 - [ ] ID-2
Reentrancy in [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100):
	External calls:
	- [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L87)
		- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	State variables written after the call(s):
	- [rewardsPerToken.lastUpdated = start](yield-utils-v2/src/token/ERC20Rewards.sol#L96)
	[ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
	- [rewardsPerToken.rate = rate](yield-utils-v2/src/token/ERC20Rewards.sol#L97)
	[ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewardsPerToken](yield-utils-v2/src/token/ERC20Rewards.sol#L44)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
	- [rewardsPeriod.start = start](yield-utils-v2/src/token/ERC20Rewards.sol#L89)
	[ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)
	- [rewardsPeriod.end = end](yield-utils-v2/src/token/ERC20Rewards.sol#L90)
	[ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20Rewards.rewardsPeriod](yield-utils-v2/src/token/ERC20Rewards.sol#L42)
	- [ERC20Rewards.setRewards(uint32,uint32,uint96)](yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100)

yield-utils-v2/src/token/ERC20Rewards.sol#L68-L100


 - [ ] ID-3
Reentrancy in [ERC20Rewards._mint(address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L142-L149):
	External calls:
	- [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L146)
		- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	- [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L147)
		- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	State variables written after the call(s):
	- [super._mint(dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L148)
		- [_balanceOf[dst] = _balanceOf[dst] + wad](yield-utils-v2/src/token/ERC20.sol#L168)
	[ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
	- [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
	- [super._mint(dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L148)
		- [_totalSupply = _totalSupply + wad](yield-utils-v2/src/token/ERC20.sol#L169)
	[ERC20._totalSupply](yield-utils-v2/src/token/ERC20.sol#L29) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20.totalSupply()](yield-utils-v2/src/token/ERC20.sol#L48-L50)

yield-utils-v2/src/token/ERC20Rewards.sol#L142-L149


 - [ ] ID-4
Reentrancy in [ERC20Rewards._burn(address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L152-L159):
	External calls:
	- [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L156)
		- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	- [_updateUserRewards(src)](yield-utils-v2/src/token/ERC20Rewards.sol#L157)
		- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	State variables written after the call(s):
	- [super._burn(src,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L158)
		- [_balanceOf[src] = _balanceOf[src] - wad](yield-utils-v2/src/token/ERC20.sol#L190)
	[ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
	- [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
	- [super._burn(src,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L158)
		- [_totalSupply = _totalSupply - wad](yield-utils-v2/src/token/ERC20.sol#L191)
	[ERC20._totalSupply](yield-utils-v2/src/token/ERC20.sol#L29) can be used in cross function reentrancies:
	- [ERC20Rewards._updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L104-L124)
	- [ERC20.totalSupply()](yield-utils-v2/src/token/ERC20.sol#L48-L50)

yield-utils-v2/src/token/ERC20Rewards.sol#L152-L159


 - [ ] ID-5
Reentrancy in [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195):
	External calls:
	- [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L190)
		- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	- [claiming = _updateUserRewards(from)](yield-utils-v2/src/token/ERC20Rewards.sol#L191)
		- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	State variables written after the call(s):
	- [rewards[from].accumulated = 0](yield-utils-v2/src/token/ERC20Rewards.sol#L192)
	[ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
	- [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195


 - [ ] ID-6
Reentrancy in [ERC20Rewards._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20Rewards.sol#L162-L167):
	External calls:
	- [_updateRewardsPerToken()](yield-utils-v2/src/token/ERC20Rewards.sol#L163)
		- [rewardsPerToken_.accumulated = (rewardsPerToken_.accumulated + 1e18 * unaccountedTime * rewardsPerToken_.rate / totalSupply_).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L119)
	- [_updateUserRewards(src)](yield-utils-v2/src/token/ERC20Rewards.sol#L164)
		- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	- [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L165)
		- [userRewards_.accumulated = (userRewards_.accumulated + _balanceOf[user] * (rewardsPerToken_.accumulated - userRewards_.checkpoint) / 1e18).u128()](yield-utils-v2/src/token/ERC20Rewards.sol#L133)
	State variables written after the call(s):
	- [super._transfer(src,dst,wad)](yield-utils-v2/src/token/ERC20Rewards.sol#L166)
		- [_balanceOf[src] = _balanceOf[src] - wad](yield-utils-v2/src/token/ERC20.sol#L117)
		- [_balanceOf[dst] = _balanceOf[dst] + wad](yield-utils-v2/src/token/ERC20.sol#L118)
	[ERC20._balanceOf](yield-utils-v2/src/token/ERC20.sol#L30) can be used in cross function reentrancies:
	- [ERC20._transfer(address,address,uint256)](yield-utils-v2/src/token/ERC20.sol#L115-L123)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20.balanceOf(address)](yield-utils-v2/src/token/ERC20.sol#L55-L57)
	- [_updateUserRewards(dst)](yield-utils-v2/src/token/ERC20Rewards.sol#L165)
		- [rewards[user] = userRewards_](yield-utils-v2/src/token/ERC20Rewards.sol#L135)
	[ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45) can be used in cross function reentrancies:
	- [ERC20Rewards._claim(address,address)](yield-utils-v2/src/token/ERC20Rewards.sol#L186-L195)
	- [ERC20Rewards._updateUserRewards(address)](yield-utils-v2/src/token/ERC20Rewards.sol#L128-L139)
	- [ERC20Rewards.rewards](yield-utils-v2/src/token/ERC20Rewards.sol#L45)

yield-utils-v2/src/token/ERC20Rewards.sol#L162-L167

### write-after-write-vault-v2
#### Recommendation
Fix or remove the writes.

#### Description
Impact: Medium
Confidence: High
Smart contract under scope: https://github.com/yieldprotocol/vault-v2/tree/main/src/mocks/oracles/OracleMock.sol
- [ ] ID-0
[OracleMock.updated](vault-v2/src/mocks/oracles/OracleMock.sol#L12) is written in both
	[updated = block.timestamp](vault-v2/src/mocks/oracles/OracleMock.sol#L25)
	[(spot * amount / 1e18,updated = block.timestamp)](vault-v2/src/mocks/oracles/OracleMock.sol#L26)

vault-v2/src/mocks/oracles/OracleMock.sol#L12

### divide-before-multiply-vault-v2
#### Recommendation
Consider ordering multiplication before division.

#### Description
Impact: Medium
Confidence: Medium
Smart contract under scope: https://github.com/yieldprotocol/vault-v2/tree/main/src/oracles/uniswap/uniswapv0.8/FullMath.sol
- [ ] ID-0
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L95)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-1
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv = (3 * denominator) ^ 2](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L87)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-2
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [prod0 = prod0 / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L72)
	- [result = prod0 * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L104)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-3
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L94)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-4
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L93)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-5
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L92)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-6
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L96)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106


- [ ] ID-7
[FullMath.mulDiv(uint256,uint256,uint256)](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L67)
	- [inv *= 2 - denominator * inv](vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L91)

vault-v2/src/oracles/uniswap/uniswapv0.8/FullMath.sol#L14-L106

## erc20-interface-vault-v2
#### Recommendation
Set the appropriate return values and types for the defined ERC20 functions.

#### Description
Impact: Medium
Confidence: High
Smart contract under scope: https://github.com/yieldprotocol/vault-v2/tree/main/src/other/tether/IUSDT.sol
- [ ] ID-0
[IUSDT](vault-v2/src/other/tether/IUSDT.sol#L7-L34) has incorrect ERC20 function interface:[IUSDT.transfer(address,uint256)](vault-v2/src/other/tether/IUSDT.sol#L28)

vault-v2/src/other/tether/IUSDT.sol#L7-L34


- [ ] ID-1
[IUSDT](vault-v2/src/other/tether/IUSDT.sol#L7-L34) has incorrect ERC20 function interface:[IUSDT.transferFrom(address,address,uint256)](vault-v2/src/other/tether/IUSDT.sol#L30)

vault-v2/src/other/tether/IUSDT.sol#L7-L34


- [ ] ID-2
[IUSDT](vault-v2/src/other/tether/IUSDT.sol#L7-L34) has incorrect ERC20 function interface:[IUSDT.approve(address,uint256)](vault-v2/src/other/tether/IUSDT.sol#L22)

vault-v2/src/other/tether/IUSDT.sol#L7-L34
