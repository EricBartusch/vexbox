extends Badge

func onOpenBox(box):
	if !unlocked and main.getStat("opens") >= 10000:
		unlock()

func getProgress():
	return main.getStat("opens")

func getMaxProgress():
	return 10000

func isPassive():
	return true

func applyPassive():
	main.badgePoints += 1
	main.refreshBadgePoints()
