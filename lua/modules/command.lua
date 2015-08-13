Command = {}

function Command:Init(commandName)
	self.name = commandName
	self.tester = 5
end

function Command:Execute()
	print(self.tester)
end

function Command:Log()

end

function Command:Undo()

end

Handler = {}

function Handler:Init(handler)
		handler.CommandList = {}
end

function Handler:ExecuteCommand(cmd)
	this.handler.append(cmd)
end

function Handler:UndoLastCommand()

end

function Handler:GetCommandLists()

end

test = Command:Init("test")
Command:Execute()


print(0)
