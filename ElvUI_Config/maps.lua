local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, ProfileDB, GlobalDB


E.Options.args.maps = {
	type = "group",
	name = L["Maps"],
	childGroups = "tab",
	args = {
		worldMap = {
			order = 1,
			type = "group",
			name = WORLD_MAP,
			args = {
				header = {
					order = 0,
					type = "header",
					name = WORLD_MAP,
				},
				smallerWorldMap = {
					order = 1,
					type = "toggle",
					name = L["Smaller World Map"],
					desc = L["Make the world map smaller."],
					descStyle = "inline",
					get = function(info) return E.global.general.smallerWorldMap end,
					set = function(info, value) E.global.general.smallerWorldMap = value; E:StaticPopup_Show("GLOBAL_RL") end,
				},
				fadeMapWhenMoving = {
					order = 2,
					type = "toggle",
					name = MAP_FADE_TEXT,
					get = function(info) return E.global.general.fadeMapWhenMoving end,
					set = function(info, value)
						E.global.general.fadeMapWhenMoving = value;
						SetCVar("mapFade", (value == true and 1 or 0))
					end,
				},
				mapAlphaWhenMoving = {
					order = 3,
					type = "range",
					name = L["Map Opacity When Moving"],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.global.general.mapAlphaWhenMoving end,
					set = function(info, value)
						E.global.general.mapAlphaWhenMoving = value;
						WORLD_MAP_MIN_ALPHA = value;
						SetCVar("mapAnimMinAlpha", value)
					end,
				},
				spacer = {
					order = 4,
					type = "description",
					name = "\n"
				},
				worldMapCoordinatesEnable = {
					order = 5,
					type = "toggle",
					name = L["World Map Coordinates"],
					desc = L["Puts coordinates on the world map."],
					descStyle = "inline",
					get = function(info) return E.global.general.WorldMapCoordinates.enable end,
					set = function(info, value) E.global.general.WorldMapCoordinates.enable = value; E:StaticPopup_Show("GLOBAL_RL") end,
					width = "full"
				},
				position = {
					order = 6,
					type = "select",
					name = L["Position"],
					get = function(info) return E.global.general.WorldMapCoordinates.position end,
					set = function(info, value) E.global.general.WorldMapCoordinates.position = value; E:GetModule("WorldMap"):PositionCoords() end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable end,
					values = {
						["TOP"] = "TOP",
						["TOPLEFT"] = "TOPLEFT",
						["TOPRIGHT"] = "TOPRIGHT",
						["BOTTOM"] = "BOTTOM",
						["BOTTOMLEFT"] = "BOTTOMLEFT",
						["BOTTOMRIGHT"] = "BOTTOMRIGHT",
					},
				},
				xOffset = {
					order = 7,
					type = "range",
					name = L["X-Offset"],
					get = function(info) return E.global.general.WorldMapCoordinates.xOffset end,
					set = function(info, value) E.global.general.WorldMapCoordinates.xOffset = value; E:GetModule("WorldMap"):PositionCoords()end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable end,
					min = -200, max = 200, step = 1,
				},
				yOffset = {
					order = 8,
					type = "range",
					name = L["Y-Offset"],
					get = function(info) return E.global.general.WorldMapCoordinates.yOffset end,
					set = function(info, value) E.global.general.WorldMapCoordinates.yOffset = value; E:GetModule("WorldMap"):PositionCoords() end,
					disabled = function() return not E.global.general.WorldMapCoordinates.enable end,
					min = -200, max = 200, step = 1,
				},
			},
		},

		minimap = {
			order = 2,
			type = "group",
			name = MINIMAP_LABEL,
			get = function(info) return E.db.general.minimap[ info[#info] ] end,
			args = {
				header = {
					order = 0,
					type = "header",
					name = MINIMAP_LABEL,
				},
				enable = { --TODO pull this out to modules config
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable/Disable the minimap. |cffFF0000Warning: This will prevent you from seeing the minimap datatexts.|r"],
					get = function(info) return E.private.general.minimap[ info[#info] ] end,
					set = function(info, value) E.private.general.minimap[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					width = "full"
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					desc = L["Adjust the size of the minimap."],
					min = 120, max = 250, step = 1,
					get = function(info) return E.db.general.minimap[ info[#info] ] end,
					set = function(info, value) E.db.general.minimap[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
					disabled = function() return not E.private.general.minimap.enable end,
				},
				locationTextGroup = {
					order = 3,
					type = "group",
					name = L["Location Text"],
					inline = true,
					args = {
						locationText = {
						    order = 1,
						    type = 'select',
						    name = L["Location Text"],
						    desc = L["Change settings for the display of the location text that is on the minimap."],
						    get = function(info) return E.db.general.minimap.locationText end,
						    set = function(info, value) E.db.general.minimap.locationText = value; E:GetModule('Minimap'):UpdateSettings(); E:GetModule('Minimap'):Update_ZoneText() end,
						    values = {
						        ['MOUSEOVER'] = L["Minimap Mouseover"],
						        ['SHOW'] = L["Always Display"],
						        ['HIDE'] = L["Hide"],
						    },
						    disabled = function() return not E.private.general.minimap.enable end,
						},
						locationFont = {
						    order = 2,
						    type = "select",
						    dialogControl = 'LSM30_Font',
						    name = L["Font"],
						    values = AceGUIWidgetLSMlists.font,
						    set = function(info, value) E.db.general.minimap.locationFont = value; E:GetModule('Minimap'):Update_ZoneText() end,
						},
						locationFontSize = {
						    order = 3,
						    type = "range",
						    name = L["Font Size"],
						    min = 10, max = 36, step = 1,
						    set = function(info, value) E.db.general.minimap.locationFontSize = value; E:GetModule('Minimap'):UpdateSettings(); E:GetModule('Minimap'):Update_ZoneText() end,
						},
						locationFontOutline = {
						    order = 4,
						    type = "select",
						    name = L["Font Outline"],
						    set = function(info, value) E.db.general.minimap.locationFontOutline = value; E:GetModule('Minimap'):Update_ZoneText() end,
						    values = {
						        ['NONE'] = L["None"],
						        ['OUTLINE'] = 'OUTLINE',
						        ['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
						        ['THICKOUTLINE'] = 'THICKOUTLINE',
						    },
						},
					},
				},
				zoomResetGroup = {
					order = 4,
					type = "group",
					name = L["Reset Zoom"], -- TODO translate
					inline = true,
					args = {
						enableZoomReset = {
							order = 1,
							type = "toggle",
							name = L["Reset zoom"],
							get = function(info) return E.db.general.minimap.resetZoom.enable end,
							set = function(info, value) E.db.general.minimap.resetZoom.enable = value; E:GetModule('Minimap'):UpdateSettings() end,
						},
						zoomRestTime = {
							order = 2,
							type = "range",
							name = L["Seconds"], --TODO translate
							min = 1, max = 15, step = 1,
							get = function(info) return E.db.general.minimap.resetZoom.time end,
							set = function(info, value) E.db.general.minimap.resetZoom.time = value; E:GetModule('Minimap'):UpdateSettings() end,
							disabled = function() return not E.db.general.minimap.resetZoom.enable end
						}
					}
				},
				spacer = {
					order = 5,
					type = "description",
					name = "\n",
				},
				icons = {
					order = 6,
					type = "group",
					name = L["Minimap Buttons"],
					args = {
						classHall = {
							order = 1,
							type = "group",
							name = GARRISON_LANDING_PAGE_TITLE,
							get = function(info) return E.db.general.minimap.icons.classHall[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.classHall[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								hideClassHallReport = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
									get = function(info) return E.private.general.minimap.hideClassHallReport end,
									set = function(info, value) E.private.general.minimap.hideClassHallReport = value; E:StaticPopup_Show("PRIVATE_RL") end,
									width = "full",
								},
								spacer = {
									order = 2,
									type = "description",
									name = "",
									width = "full"
								},
								position = {
									order = 3,
									type = "select",
									name = L["Position"],
									disabled = function() return E.private.general.minimap.hideClassHallReport end,
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 4,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05
								},


								xOffset = {
									order = 5,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideClassHallReport end,
								},
								yOffset = {
									order = 6,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideClassHallReport end,
								},

							},
						},
						calendar = {
							order = 2,
							type = "group",
							name = L["Calendar"],
							get = function(info) return E.db.general.minimap.icons.calendar[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.calendar[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								hideCalendar = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
									get = function(info) return E.private.general.minimap.hideCalendar end,
									set = function(info, value) E.private.general.minimap.hideCalendar = value; E:GetModule('Minimap'):UpdateSettings() end,
									width = "full"
								},
								spacer = {
									order = 2,
									type = "description",
									name = "",
									width = "full"
								},
								position = {
									order = 3,
									type = "select",
									name = L["Position"],
									disabled = function() return E.private.general.minimap.hideCalendar end,
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 4,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},
								xOffset = {
									order = 5,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideCalendar end,
								},
								yOffset = {
									order = 6,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
									disabled = function() return E.private.general.minimap.hideCalendar end,
								},

							},
						},
						mail = {
							order = 3,
							type = "group",
							name = MAIL_LABEL,
							get = function(info) return E.db.general.minimap.icons.mail[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.mail[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},
								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},
							},
						},
						lfgEye = {
							order = 4,
							type = "group",
							name = L["LFG Queue"],
							get = function(info) return E.db.general.minimap.icons.lfgEye[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.lfgEye[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},

								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},
							},
						},
						difficulty = {
							order = 5,
							type = "group",
							name = L["Instance Difficulty"],
							get = function(info) return E.db.general.minimap.icons.difficulty[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.difficulty[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},

								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},
							},
						},
						challengeMode = {
							order = 6,
							type = "group",
							name = CHALLENGE_MODE,
							get = function(info) return E.db.general.minimap.icons.challengeMode[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.challengeMode[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},

								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},
							},
						},
						vehicleLeave = {
							order = 7,
							type = "group",
							name = LEAVE_VEHICLE,
							get = function(info) return E.db.general.minimap.icons.vehicleLeave[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.vehicleLeave[ info[#info] ] = value; E:GetModule('ActionBars'):UpdateVehicleLeave() end,
							args = {
								hide = {
									order = 1,
									type = "toggle",
									name = L["Hide"],
								},
								spacer = {
									order = 2,
									type = "description",
									name = "",
									width = "full"
								},
								position = {
									order = 3,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 4,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},

								xOffset = {
									order = 5,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 6,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},

							},
						},
						ticket = {
							order = 8,
							type = "group",
							name = L["Open Ticket"],
							get = function(info) return E.db.general.minimap.icons.ticket[ info[#info] ] end,
							set = function(info, value) E.db.general.minimap.icons.ticket[ info[#info] ] = value; E:GetModule('Minimap'):UpdateSettings() end,
							args = {
								position = {
									order = 1,
									type = "select",
									name = L["Position"],
									values = {
										["LEFT"] = L["Left"],
										["RIGHT"] = L["Right"],
										["TOP"] = L["Top"],
										["BOTTOM"] = L["Bottom"],
										["TOPLEFT"] = L["Top Left"],
										["TOPRIGHT"] = L["Top Right"],
										["BOTTOMLEFT"] = L["Bottom Left"],
										["BOTTOMRIGHT"] = L["Bottom Right"],
									},
								},
								scale = {
									order = 2,
									type = "range",
									name = L["Scale"],
									min = 0.5, max = 2, step = 0.05,
								},

								xOffset = {
									order = 3,
									type = "range",
									name = L["xOffset"],
									min = -50, max = 50, step = 1,
								},
								yOffset = {
									order = 4,
									type = "range",
									name = L["yOffset"],
									min = -50, max = 50, step = 1,
								},
							},
						},
					},
				},
			}
		}
	}
}
