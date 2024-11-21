extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 500:
		unlock()

func getProgress():
	return main.wins

func getMaxProgress():
	return 500

func isPassive():
	return true

func applyPassive():
	main.badgePoints += 1
	main.updateBadgePoints()
