Feature: Follow disposal history
        Disposal history is: created approved legalized delivered conpleted

  Scenario: A new disposal is first approved and can only be approved
    Given A new disposal
    When It is legalized
    Then You get an history error
    When It is delivered
    Then You get an history error
    When It is completed
    Then You get an history error
    When It is approved
    Then It should be approved

    


