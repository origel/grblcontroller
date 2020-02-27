import vui
import gx
import os

const (
	win_width = 700
	win_height = 385
	nr_cols = 4
	cell_height = 25
	cell_width = 100
	table_width = cell_width * nr_cols
)

struct User {
	first_name string
	last_name  string
	age        int
	country    string
}

struct App {
mut:
	first_name vui.TextBox
	last_name  vui.TextBox
	age        vui.TextBox
	password   vui.TextBox
	pbar       vui.ProgressBar
	users      []User
	window     &vui.Window
	label      vui.Label
	country    vui.Radio
	txt_pos    int
}

fn main() {
	mut app := &App{
		users: [
			User{
				first_name: 'Sam'
				last_name: 'Johnson'
				age: 29
				country: 'United States'
			},
			User{
				first_name: 'Kate'
				last_name: 'Williams'
				age: 26
				country: 'Canada'
			}
		]
	}
	window := vui.window({
		width: win_width
		height: win_height
		user_ptr: app
		title: 'GrblController'
	}, [
		vui.IWidgeter(vui.row({
			stretch: true,
			margin: vui.MarginConfig{10,10,10,10}
		}, [
			vui.IWidgeter(vui.column({
				width: 200
				spacing: 13
			}, [
                vui.IWidgeter(vui.row({
                    spacing: 50
                }, [
                    vui.IWidgeter(vui.textbox({
                        max_len: 20
                        width: 100
                        placeholder: 'Serial Port'
                    })),
                    vui.button({
                        text: 'Open'
                        onclick: btn_help_click
                    })
                ])),
				vui.textbox({
					max_len: 50
					width: 200
					placeholder: 'Last name'
					ref: &app.last_name
				}),
				vui.textbox({
					max_len: 3
					width: 200
					placeholder: 'Age'
					is_numeric: true
					ref: &app.age
				}),
				vui.textbox({
					width: 200
					placeholder: 'Password'
					is_password: true
					max_len: 20
					ref: &app.password
				}),
				vui.checkbox({
					checked: true
					text: 'Online registration'
				}),
				vui.checkbox({
					text: 'Subscribe to the newsletter'
				}),
				vui.radio({
					width: 200
					values: ['United States', 'Canada', 'United Kingdom', 'Australia']
					title: 'Country'
					ref: &app.country
				}),
				vui.row({
					spacing: 85
				}, [
					vui.IWidgeter(vui.button({
						text: 'Add user'
						onclick: btn_add_click
					})),
					vui.button({
						text: '?'
						onclick: btn_help_click
					})
				]),
				vui.row({
					spacing: 5
					alignment: .center
				}, [
					vui.IWidgeter(vui.progressbar({
						width: 170
						max: 10
						val: 2
						ref: &app.pbar
					})),
					vui.label({
						text: '2/10'
						ref: &app.label
					})
				])
			])),
			vui.IWidgeter(vui.column({
				stretch: true
				alignment: .right
			},[
				vui.IWidgeter(vui.canvas({
					height: 275
					draw_fn:canvas_draw
				})),
				vui.picture({
					width: 100
					height: 100
					path: os.resource_abs_path( 'logo.png' )
				})
			]))
		]))
	])
	app.window = window
	vui.run(window)
}

fn menu_click() {

}

fn btn_help_click() {
	vui.message_box('Bvuilt with V vui')
}

fn btn_add_click(app mut App) {
	//vui.notify('user', 'done')
	//app.window.set_cursor(.hand)
	if app.users.len >= 10 {
		return
	}
	if app.first_name.text == '' ||  app.last_name.text == '' {
		return
	}
	new_user := User{
		first_name: app.first_name.text
		last_name: app.last_name.text
		age: app.age.text.int()
		country: app.country.selected_value()
	}
	app.users << new_user
	app.pbar.val++
	app.first_name.set_text('')
	app.first_name.focus()
	app.last_name.set_text('')
	app.age.set_text('')
	app.password.set_text('')
	app.label.set_text('$app.users.len/10')
	//vui.message_box('$new_user.first_name $new_user.last_name has been added')
}

fn canvas_draw(app &App) {
	gg := app.window.ui.gg
	mut ft := app.window.ui.ft
	x := 240
	gg.draw_rect(x - 20, 0, table_width + 100, 800, gx.white)
	for i, user in app.users {
		y := 20 + i * cell_height
		// Outer border
		gg.draw_empty_rect(x, y, table_width, cell_height, gx.Gray)
		// Vertical separators
		gg.draw_line(x + cell_width, y, x + cell_width, y + cell_height, gx.Gray)
		gg.draw_line(x + cell_width * 2, y, x + cell_width * 2, y + cell_height, gx.Gray)
		gg.draw_line(x + cell_width * 3, y, x + cell_width * 3, y + cell_height, gx.Gray)
		// Text values
		ft.draw_text_def(x + 5, y + 5, user.first_name)
		ft.draw_text_def(x + 5 + cell_width, y + 5, user.last_name)
		ft.draw_text_def(x + 5 + cell_width * 2, y + 5, user.age.str())
		ft.draw_text_def(x + 5 + cell_width * 3, y + 5, user.country)
	}
}
