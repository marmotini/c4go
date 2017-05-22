package ast

type WarnUnusedResultAttr struct {
	Address  string
	Position string
	Children []Node
}

func parseWarnUnusedResultAttr(line string) *WarnUnusedResultAttr {
	groups := groupsFromRegex(`<(?P<position>.*)>( warn_unused_result)?`, line)

	return &WarnUnusedResultAttr{
		Address:  groups["address"],
		Position: groups["position"],
		Children: []Node{},
	}
}

func (n *WarnUnusedResultAttr) AddChild(node Node) {
	n.Children = append(n.Children, node)
}
