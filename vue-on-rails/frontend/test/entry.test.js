import test from 'ava';
import app from '../src/entry';

test('app#shout', t => {
	t.is(app.$data.message, 'hello');
	app.shout();
	t.is(app.$data.message, 'hello!!!!!!!!!!');
});
